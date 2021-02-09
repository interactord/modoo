import Nimble
import Quick
@testable import Application

class RegisterInteractorSpec: QuickSpec {
  override func spec() {
    // swiftlint:disable implicitly_unwrapped_optional
    var interactor: RegisterInteractor!
    // swiftlint:disable implicitly_unwrapped_optional
    var viewController: RegisterViewControllableMock!
    // swiftlint:disable implicitly_unwrapped_optional
    var listener: RegisterListenerMock!
    // swiftlint:disable implicitly_unwrapped_optional
    var router: RegisterRoutingMock!

    beforeEach {
      viewController = RegisterViewControllableMock()
      listener = RegisterListenerMock()
      let state = RegisterDisplayModel.State.initialState()
      interactor = RegisterInteractor(
        presenter: viewController,
        initialState: state)
      router = RegisterRoutingMock(
        interactable: interactor,
        viewControllable: viewController)
      interactor.listener = listener
      interactor.router = router
    }
    afterEach {
      interactor = nil
      viewController = nil
      listener = nil
      router = nil
    }

    describe("RegisterInteractor activate 실행시") {
      beforeEach {
        interactor.activate()
      }
      afterEach {
        interactor.deactivate()
      }

      context("포토 action 이벤트 발생시") {
        beforeEach {
          interactor.action.onNext(.photo(nil))
        }

        it("State 포토가 변경된다") {
          expect(interactor.currentState.photo).to(beNil())
        }
      }

      context("이메일 action 이벤트 발생시") {
        beforeEach {
          interactor.action.onNext(.email("123456"))
        }

        it("State 이메일이 변경된다") {
          expect(interactor.currentState.email) == "123456"
        }
      }

      context("패스워드 action 이벤트 발생시") {
        beforeEach {
          interactor.action.onNext(.password("123456"))
        }

        it("State 페스워드가 변경된다") {
          expect(interactor.currentState.password) == "123456"
        }
      }

      context("이름 action 이벤트 발생시") {
        beforeEach {
          interactor.action.onNext(.fullName("123456"))
        }

        it("State 이름이 변경된다") {
          expect(interactor.currentState.fullName) == "123456"
        }
      }

      context("아이디 action 이벤트 발생시") {
        beforeEach {
          interactor.action.onNext(.userName("123456"))
        }

        it("State 이름이 변경된다") {
          expect(interactor.currentState.userName) == "123456"
        }
      }

      context("signUp action 이벤트 발생시") {
        beforeEach {
          interactor.action.onNext(.signUp)
        }

        it("listener routeToOnboardCallCount가 1이다") {
          expect(listener.routeToOnboardCallCount).toEventually(equal(1), timeout: .milliseconds(300))
        }
      }

      context("register action 이벤트 발생시") {
        beforeEach {
          interactor.action.onNext(.login)
        }

        it("listener routeToLogInCallCount가 1이다") {
          expect(listener.routeToLogInCallCount).toEventually(equal(1), timeout: .milliseconds(300))
        }
      }
    }
  }
}
