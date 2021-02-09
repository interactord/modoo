import Nimble
import Quick

@testable import Application

class LoginVIewControllerSpec: QuickSpec {
  override func spec() {
    // swiftlint:disable implicitly_unwrapped_optional
    var viewController: LoginViewController!
    // swiftlint:disable implicitly_unwrapped_optional
    var interactor: LoginInteractor!

    beforeEach {
      viewController = LoginViewController()
      let state = LoginDisplayModel.State.initialState()
      interactor = LoginInteractor(presenter: viewController, initialState: state)
      interactor.isStubEnabled = true
      viewController.listener = interactor
    }
    afterEach {
      viewController = nil
      interactor = nil
    }

    describe("LoginViewController 화면 노출 후") {
      beforeEach {
        viewController.viewDidLoad()
        viewController.viewDidLayoutSubviews()
      }

      context("사용자가 이메일을 입력할 경우,") {
        beforeEach {
          viewController.node.emailInputNode.textView?.text = "123456789"
          viewController.node.emailInputNode.textView?.sendActions(for: .valueChanged)
        }

        it("interactor의 액션 email로 전달이 된다") {
          expect(interactor.stub.actions.last) == LoginPresentableAction.email("123456789")
        }
      }

      context("사용자가 이메일을 빈값으로 입력한 경우,") {
        beforeEach {
          viewController.node.emailInputNode.textView?.text = nil
          viewController.node.emailInputNode.textView?.sendActions(for: .valueChanged)
        }

        it("interactor의 액션 email로 전달이 된다") {
          expect(interactor.stub.actions.last) == LoginPresentableAction.email("")
        }
      }

      context("사용자가 비밀번호를 입력할 경우") {
        beforeEach {
          viewController.node.passwordInputNode.textView?.text = "123456789"
          viewController.node.passwordInputNode.textView?.sendActions(for: .valueChanged)
        }

        it("interactor의 액션 password로 전달이 된다") {
          expect(interactor.stub.actions.last) == LoginPresentableAction.password("123456789")
        }
      }

      context("사용자가 로그인 버튼을 탭하는경우 경우") {
        beforeEach {
          viewController.node.loginButtonNode.isEnabled = true
          viewController.node.loginButtonNode.sendActions(forControlEvents: .touchUpInside, with: .none)
        }

        it("interactor의 액션 login으로 전달이 된다") {
          expect(interactor.stub.actions.last) == LoginPresentableAction.login
        }
      }

      context("사용자가 회원가입 버튼을 탭하는경우 경우") {
        beforeEach {
          viewController.node.dontHaveAccountButtonNode.sendActions(forControlEvents: .touchUpInside, with: .none)
        }

        it("interactor의 액션 register로 전달이 된다") {
          expect(interactor.stub.actions.last) == LoginPresentableAction.register
        }
      }
    }
  }
}
