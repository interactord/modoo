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
    // swiftlint:disable implicitly_unwrapped_optional
    var authenticationUseCase: AuthenticationUseCase!
    // swiftlint:disable implicitly_unwrapped_optional
    var firebaseAuthenticatingMock: FirebaseAuthenticatingMock!
    // swiftlint:disable implicitly_unwrapped_optional
    var firebaseMediaUploadingMock: FirebaseMediaUploadingMock!
    // swiftlint:disable implicitly_unwrapped_optional
    var firebaseAPINetworkingMock: FirebaseAPINetworkingMock!
    // swiftlint:disable implicitly_unwrapped_optional
    var currentState: RegisterDisplayModel.State?

    beforeEach {
      viewController = RegisterViewControllableMock()
      listener = RegisterListenerMock()
      firebaseAuthenticatingMock = FirebaseAuthenticatingMock()
      firebaseAPINetworkingMock = FirebaseAPINetworkingMock()
      firebaseMediaUploadingMock = FirebaseMediaUploadingMock()
      authenticationUseCase = FirebaseAuthenticationUseCase(
        authenticating: firebaseAuthenticatingMock,
        uploading: firebaseMediaUploadingMock,
        apiNetworking: firebaseAPINetworkingMock)
      let state = RegisterDisplayModel.State.initialState()
      interactor = RegisterInteractor(
        presenter: viewController,
        initialState: state,
        authenticationUseCase: authenticationUseCase)
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
      authenticationUseCase = nil
      firebaseAuthenticatingMock = nil
      firebaseAPINetworkingMock = nil
      firebaseMediaUploadingMock = nil
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

      context("현재 네트워크가 로딩중일 경우") {
        beforeEach {
          interactor.action.onNext(.loading(true))
          currentState = interactor.currentState
        }

        context("signUp action 이벤트 발생시") {
          beforeEach {
            interactor.action.onNext(.signUp)
          }

          it("current State는 네트워크 전 값과 동일하다") {
            expect(currentState) == interactor.currentState
          }
        }
      }

      context("현재 네트워크가 로딩중이 아닐 경우") {
        beforeEach {
          interactor.action.onNext(.loading(false))
        }

        context("signUp action 이벤트 발생시 회원가입 요청이 정상인 경우") {
          beforeEach {
            firebaseMediaUploadingMock.isSueccedCase = true

            interactor.action.onNext(.signUp)
          }

          it("state errorMessage는 빈값이다") {
            expect(interactor.currentState.errorMessage).toEventually(equal(""), timeout: TestUtil.Const.timeout)
          }

          it("listener routeToOnboard는 1이 된다") {
            expect(listener.routeToOnboardCallCount).toEventually(equal(1), timeout: TestUtil.Const.timeout)
          }
        }

        context("signUp action 이벤트 발생시 회원가입 요청이 에러가 발생한 경우") {
          beforeEach {
            firebaseMediaUploadingMock.isSueccedCase = false

            interactor.action.onNext(.signUp)
          }

          it("state errorMessage는 빈값이 아니다") {
            expect(interactor.currentState.errorMessage).toNotEventually(equal(""), timeout: TestUtil.Const.timeout)
          }

          it("listener routeToOnboard는 0이 된다") {
            expect(listener.routeToOnboardCallCount).toEventually(equal(0), timeout: TestUtil.Const.timeout)
          }
        }
      }

      context("register action 이벤트 발생시") {
        beforeEach {
          interactor.action.onNext(.login)
        }

        it("listener routeToLogInCallCount가 1이다") {
          expect(listener.routeToLogInCallCount).toEventually(equal(1), timeout: TestUtil.Const.timeout)
        }
      }
    }
  }
}
