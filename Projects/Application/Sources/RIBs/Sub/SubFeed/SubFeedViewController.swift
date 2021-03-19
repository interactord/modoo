import AsyncDisplayKit
import ReactorKit
import RIBs
import RxSwift
import UIKit

// MARK: - SubFeedPresentableAction

enum SubFeedPresentableAction {
  case tapClose
}

// MARK: - SubFeedPresentableListener

protocol SubFeedPresentableListener: AnyObject {
  typealias Action = SubFeedPresentableAction
  typealias State = SubFeedDisplayModel.State

  var action: ActionSubject<Action> { get }
  var state: Observable<State> { get }
  var currentState: State { get }
}

// MARK: - SubFeedViewController

final class SubFeedViewController: ASDKViewController<SubFeedContainerNode>, SubFeedPresentable, SubFeedViewControllable {

  // MARK: Lifecycle

  deinit {
    print("SubFeedViewController deinit...")
  }

  // MARK: Internal

  let disposeBag = DisposeBag()

  weak var listener: SubFeedPresentableListener? {
    didSet { bind(listener: listener) }
  }

  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
  }

}

// MARK: ListenerBindable

extension SubFeedViewController: ListenerBindable {

  func bindAction(listener: SubFeedPresentableListener) {
    node.backButtonTabStream
      .mapTo(.tapClose)
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }

  func bindState(listener: SubFeedPresentableListener) {
  }
}
