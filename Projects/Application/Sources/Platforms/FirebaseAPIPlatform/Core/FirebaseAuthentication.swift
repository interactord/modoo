import FirebaseAuth
import Foundation
import RxSwift

struct FirebaseAuthentication: FirebaseAuthenticating {

  var authenticationToken: String {
    Auth.auth().currentUser?.uid ?? ""
  }

  func create(email: String, password: String) -> Single<String> {
    .create { single in
      Auth.auth()
        .createUser(withEmail: email, password: password) { result, error in
          if let error = error { single(.failure(error)) }
          single(.success(result?.user.uid ?? ""))
        }

      return Disposables.create()
    }
  }
}
