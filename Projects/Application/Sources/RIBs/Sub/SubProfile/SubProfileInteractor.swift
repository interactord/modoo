import ReactorKit
import RIBs
import RxSwift

// MARK: - SubProfileRouting

protocol SubProfileRouting: ViewableRouting {
}

// MARK: - SubProfilePresentable

protocol SubProfilePresentable: Presentable {
  var listener: SubProfilePresentableListener? { get set }
}

// MARK: - SubProfileListener

protocol SubProfileListener: AnyObject {
  func routeToBack()
}

// MARK: - SubProfileInteractor

final class SubProfileInteractor: PresentableInteractor<SubProfilePresentable>, SubProfileInteractable {

  // MARK: Lifecycle

  init(
    presenter: SubProfilePresentable,
    initialState: ProfileDisplayModel.State,
    userUseCase: UserUseCase,
    postUseCase: PostUseCase,
    uid: String)
  {
    defer { presenter.listener = self }
    self.initialState = initialState
    self.uid = uid
    self.userUseCase = userUseCase
    self.postUseCase = postUseCase
    super.init(presenter: presenter)
  }

  deinit {
    print("SubProfileInteractor deinit...")
  }

  // MARK: Internal

  typealias Action = SubProfilePresentableAction
  typealias State = ProfileDisplayModel.State

  enum Mutation: Equatable {
    case setUserProfile(ProfileDisplayModel.InformationSectionItem)
    case setPosts([ProfileDisplayModel.MediaContentSectionItem.CellItem])
    case setError(String)
    case setLoading(Bool)
    case setFollow(Bool)
  }

  weak var router: SubProfileRouting?
  weak var listener: SubProfileListener?

  var initialState: ProfileDisplayModel.State

  // MARK: Private

  private let uid: String
  private let userUseCase: UserUseCase
  private let postUseCase: PostUseCase

}

// MARK: SubProfilePresentableListener, Reactor

extension SubProfileInteractor: SubProfilePresentableListener, Reactor {

  // MARK: Internal

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .load:
      return mutatingLoad(uid: uid)
    case let .loading(isLoading):
      return .just(.setLoading(isLoading))
    case .back:
      return mutatingBack()
    case .follow:
      return mutatingFollow(uid: uid)
    case .unFollow:
      return mutatingUnFollow(uid: uid)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setUserProfile(informationSectionItem):
      let sectionID = state.informationSectionItemModel.sectionID
      newState.informationSectionItemModel = .init(sectionID: sectionID, sectionItem: informationSectionItem)
    case let .setPosts(cellItems):
      let sectionID = state.contentsSectionItemModel.sectionID
      let newSectionItem = ProfileDisplayModel.MediaContentSectionItem(headerItem: state.contentsSectionItemModel.headerItem, cellItems: cellItems)
      newState.contentsSectionItemModel = .init(sectionID: sectionID, sectionItem: newSectionItem)
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
    case let .setError(message):
      newState.errorMessage = message
    case let .setFollow(isFollow):
      let sectionID = state.informationSectionItemModel.sectionID
      var headerItem = newState.informationSectionItemModel.headerItem
      headerItem.isFollowed = isFollow
      newState.informationSectionItemModel = .init(sectionID: sectionID, sectionItem: .init(headerItem: headerItem))
    }

    return newState
  }

  // MARK: Private

  private func mutatingLoad(uid: String) -> Observable<Mutation> {
    guard !currentState.isLoading else { return .empty() }

    let startLoading = Observable.just(Mutation.setLoading(true))
    let stopLoading = Observable.just(Mutation.setLoading(false))
    let userUseCaseStream = Observable.zip(
      userUseCase.fetchUser(uid: uid),
      userUseCase.fetchUserSocial(uid: uid),
      userUseCase.isFollowed(uid: uid))
      .flatMap { userModel, socialModel, isFollowed -> Observable<Mutation> in
        let model = ProfileDisplayModel.InformationSectionItem(userRepositoryModel: userModel, socialRepositoryModel: socialModel, isFollowed: isFollowed)
        return .just(.setUserProfile(model))
      }
      .catch { .just(.setError($0.localizedDescription)) }
    let postUseCaseStream = postUseCase.fetchPosts(uid: uid).flatMap { postReposityModel -> Observable<Mutation> in
      let models = postReposityModel.map{ ProfileDisplayModel.MediaContentSectionItem.CellItem(id: $0.id, imageURL: $0.imageURL) }
      return .just(.setPosts(models))
    }
    .catch { .just(.setError($0.localizedDescription)) }

    return Observable.concat([startLoading, userUseCaseStream, postUseCaseStream, stopLoading])
  }

  private func mutatingBack() -> Observable<Mutation> {
    listener?.routeToBack()
    return .empty()
  }

  private func mutatingFollow(uid: String) -> Observable<Mutation> {
    guard !currentState.isLoading else { return .empty() }

    let startLoading = Observable.just(Mutation.setLoading(true))
    let stopLoading = Observable.just(Mutation.setLoading(false))
    let useCaseStream = userUseCase.follow(to: uid).flatMap { _ -> Observable<Mutation> in
      .just(.setFollow(true))
    }
    .catch { .just(.setError($0.localizedDescription)) }

    return Observable.concat([startLoading, useCaseStream, stopLoading])
  }

  private func mutatingUnFollow(uid: String) -> Observable<Mutation> {
    guard !currentState.isLoading else { return .empty() }

    let startLoading = Observable.just(Mutation.setLoading(true))
    let stopLoading = Observable.just(Mutation.setLoading(false))
    let useCaseStream = userUseCase.unFollow(to: uid).flatMap { _ -> Observable<Mutation> in
      .just(.setFollow(false))
    }
    .catch { .just(.setError($0.localizedDescription)) }

    return Observable.concat([startLoading, useCaseStream, stopLoading])
  }

}
