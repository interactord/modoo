import FirebaseAuth
import RIBs
import RxSwift
import UIKit

// MARK: - OnboardPresentableListener

protocol OnboardPresentableListener: AnyObject {
}

// MARK: - OnboardViewController

final class OnboardViewController: UITabBarController, OnboardPresentable, OnboardViewControllable {

  // MARK: Lifecycle

  deinit {
    print("OnboardViewController deinit...")
  }

  // MARK: Internal

  weak var listener: OnboardPresentableListener?

  override func viewDidLoad() {
    super.viewDidLoad()

    do {
      try Auth.auth().signOut()
    } catch {
      print(error)
    }

    view.backgroundColor = .green
  }

}
