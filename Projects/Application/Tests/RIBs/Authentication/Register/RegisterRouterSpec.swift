import Nimble
import Quick
@testable import Application

class RegisterRouterSpec: QuickSpec {
  override func spec() {
    // swiftlint:disable implicitly_unwrapped_optional
    var router: RegisterRouter!
    // swiftlint:disable implicitly_unwrapped_optional
    var viewController: RegisterViewControllableMock!
    // swiftlint:disable implicitly_unwrapped_optional
    var interactor: RegisterInteractableMock!

    beforeEach {
      interactor = RegisterInteractableMock()
      viewController = RegisterViewControllableMock()
      router = RegisterRouter(interactor: interactor, viewController: viewController)
    }
    afterEach {
      router = nil
      viewController = nil
      interactor = nil
    }

    describe("LoginRouter didLoad 실행시") {
      beforeEach {
        router.didLoad()
      }
    }
  }
}
