import RxSwift
import UIKit

// MARK: - TestError

enum TestError: Error, LocalizedError {
  case test
  var errorDescription: String? {
    "test"
  }
}

// MARK: - FirebaseAuthenticationUseCase

struct FirebaseAuthenticationUseCase: AuthenticationUseCase {

  // MARK: Internal

  let authenticating: FirebaseAuthenticating
  let mediaUploading: FirebaseMediaUploading
  let apiNetworking: FirebaseAPINetworking

  var authenticationToken: String {
    authenticating.authenticationToken
  }

  func register(domain: RegisterDisplayModel.State) -> Observable<Void> {
    Observable.zip(
      authenticating.create(email: domain.email, password: domain.password).asObservable(),
      mediaUploading.upload(image: domain.photo, directoryName: Const.directoryName).asObservable())
      .map { uid, imagePath -> (String, String, [String: Any]) in
        let dictionary: [String: Any] = [
          "uid": uid,
          "email": domain.email,
          "profileImageURL": imagePath,
          "username": domain.userName,
          "fullname": domain.fullName,
        ]
        return (uid, Const.collectionName, dictionary)
      }
      .flatMap { apiNetworking.create(uid: $0.0, collection: $0.1, dictionary: $0.2) }
  }

  func login(domain: LoginDisplayModel.State) -> Observable<Void> {
    authenticating
      .login(email: domain.email, password: domain.password)
      .asObservable()
  }

  func logout() {
    authenticating.logout()
  }

  // MARK: Private

  private struct Const {
    static var directoryName = "profile_images"
    static var collectionName = "users"
  }

}
