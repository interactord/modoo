import UIKit

import RIBs

// MARK: - AuthenticationInteractable

protocol AuthenticationInteractable: Interactable, LoginListener, RegisterListener {
  var router: AuthenticationRouting? { get set }
  var listener: AuthenticationListener? { get set }
}

// MARK: - AuthenticationViewControllable

protocol AuthenticationViewControllable: ViewControllable {
  func setRootViewController(viewController: ViewControllable)
  func pushViewController(viewController: ViewControllable)
  func popToRootViewController()
}

// MARK: - AuthenticationRouter

final class AuthenticationRouter: ViewableRouter<AuthenticationInteractable, AuthenticationViewControllable> {

  // MARK: Lifecycle

  init(
    interactor: AuthenticationInteractable,
    viewController: AuthenticationViewControllable,
    loginBuilder: LoginBuildable,
    registerBuilder: RegisterBuildable)
  {
    self.loginBuilder = loginBuilder
    self.registerBuilder = registerBuilder

    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }

  deinit {
    print("AuthenticationRouter deinit")
  }

  // MARK: Internal

  override func didLoad() {
    super.didLoad()

    routeToLogin()
  }

  // MARK: Private

  private let loginBuilder: LoginBuildable
  private let registerBuilder: RegisterBuildable
  private weak var loginRouting: ViewableRouting?
  private weak var registerRouting: ViewableRouting?
}

// MARK: AuthenticationRouting

extension AuthenticationRouter: AuthenticationRouting {

  func cleanupViews() {
    guard let registerRoutring = registerRouting else { return }

    detachChild(registerRoutring)
    viewController.popToRootViewController()
  }

  func routeToLogin() {
    cleanupViews()

    guard loginRouting == nil else { return }

    let loginRouting = loginBuilder.build(withListener: interactor)
    attachChild(loginRouting)
    self.loginRouting = loginRouting

    viewController.setRootViewController(viewController: loginRouting.viewControllable)
  }

  func routeToRegister() {
    cleanupViews()

    let registerRouting = registerBuilder.build(withListener: interactor)
    attachChild(registerRouting)
    self.registerRouting = registerRouting

    viewController.pushViewController(viewController: registerRouting.viewControllable)
  }

}
