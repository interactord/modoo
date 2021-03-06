import ReactorKit
import RIBs
import RxSwift

// MARK: - RegisterRouting

protocol RegisterRouting: ViewableRouting {}

// MARK: - RegisterPresentable

protocol RegisterPresentable: Presentable {
  var listener: RegisterPresentableListener? { get set }
}

// MARK: - RegisterListener

protocol RegisterListener: AnyObject {
  func routeToLogin()
  func routeToOnboard()
}

// MARK: - RegisterInteractor

final class RegisterInteractor: PresentableInteractor<RegisterPresentable>, RegisterInteractable {

  // MARK: Lifecycle

  init(
    presenter: RegisterPresentable,
    initialState: RegisterDisplayModel.State,
    authenticationUseCase: AuthenticationUseCase)
  {
    defer { presenter.listener = self }
    self.initialState = initialState
    self.authenticationUseCase = authenticationUseCase
    super.init(presenter: presenter)
  }

  deinit {
    print("RegisterInteractor deinit...")
  }

  // MARK: Internal

  enum Mutation: Equatable {
    case setPhoto(UIImage?)
    case setEmail(String)
    case setPassword(String)
    case setFullName(String)
    case setUserName(String)
    case setLoading(Bool)
    case setError(String)
  }

  typealias Action = RegisterPresentableAction
  typealias State = RegisterDisplayModel.State

  weak var router: RegisterRouting?
  weak var listener: RegisterListener?

  let initialState: State
  let authenticationUseCase: AuthenticationUseCase

}

// MARK: RegisterPresentableListener, Reactor

extension RegisterInteractor: RegisterPresentableListener, Reactor {

  // MARK: Internal

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .login:
      return mutatingLogin()
    case .signUp:
      return mutatingRequestSignUp()
    case  let .photo(image):
      return .just(.setPhoto(image))
    case let .email(text):
      return .just(.setEmail(text))
    case let .password(text):
      return .just(.setPassword(text))
    case let .fullName(text):
      return .just(.setFullName(text))
    case let .userName(text):
      return .just(.setUserName(text))
    case let .loading(isLoading):
      return .just(.setLoading(isLoading))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case  let .setPhoto(image):
      newState.photo = image
    case let .setEmail(text):
      newState.email = text
    case let .setPassword(text):
      newState.password = text
    case let .setFullName(text):
      newState.fullName = text
    case let .setUserName(text):
      newState.userName = text
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
    case let .setError(message):
      newState.errorMessage = message
    }

    return newState
  }

  // MARK: Private

  private func mutatingLogin() -> Observable<Mutation> {
    listener?.routeToLogin()
    return .empty()
  }

  private func mutatingRequestSignUp() -> Observable<Mutation> {
    guard !currentState.isLoading else { return .empty() }

    let startLoading = Observable.just(Mutation.setLoading(true))
    let stopLoading = Observable.just(Mutation.setLoading(false))
    let useCaseStream = authenticationUseCase
      .register(domain: currentState)
      .withUnretained(self)
      .observe(on: MainScheduler.asyncInstance)
      .flatMap { owner, _ -> Observable<Mutation> in
        owner.listener?.routeToOnboard()
        return .empty()
      }
      .catch { .just(.setError($0.localizedDescription)) }

    return Observable.concat([startLoading, useCaseStream, stopLoading])
  }

}
