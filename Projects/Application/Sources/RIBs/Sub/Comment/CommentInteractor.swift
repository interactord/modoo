import ReactorKit
import RIBs
import RxSwift

// MARK: - CommentRouting

protocol CommentRouting: ViewableRouting {
}

// MARK: - CommentPresentable

protocol CommentPresentable: Presentable {
  var listener: CommentPresentableListener? { get set }
}

// MARK: - CommentListener

protocol CommentListener: AnyObject {
  func routeToBackFromComment()
}

// MARK: - CommentInteractor

final class CommentInteractor: PresentableInteractor<CommentPresentable>, CommentInteractable {

  // MARK: Lifecycle

  init(
    presenter: CommentPresentable,
    initialState: CommentDisplayModel.State)
  {
    defer { presenter.listener = self }
    self.initialState = initialState
    super.init(presenter: presenter)
  }

  deinit {
    print("CommentInteractor deinit...")
  }

  // MARK: Internal

  weak var router: CommentRouting?
  weak var listener: CommentListener?

  var initialState: CommentDisplayModel.State

}

// MARK: CommentPresentableListener, Reactor

extension CommentInteractor: CommentPresentableListener, Reactor {

  // MARK: Internal

  typealias Action = CommentDisplayModel.Action
  typealias State = CommentDisplayModel.State
  typealias Mutation = CommentDisplayModel.Mutation

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .back:
      return mutatingBack()
    }
  }

  // MARK: Private

  private func mutatingBack() -> Observable<Mutation> {
    listener?.routeToBackFromComment()
    return .empty()
  }
}
