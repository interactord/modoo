import Nimble
import Quick

@testable import Application

class RegisterContainerNodeSpec: QuickSpec {
  override func spec() {
    // swiftlint:disable implicitly_unwrapped_optional
    var node: RegisterContainerNode!

    let emailScope = FormTextInputReactor.Scope.email
    let passwordScope = FormTextInputReactor.Scope.password
    let fullNameScope = FormTextInputReactor.Scope.plain(placeholderString: "fullNameScope")
    let userNameScope = FormTextInputReactor.Scope.plain(placeholderString: "userNameScope")

    beforeEach {
      node = RegisterContainerNode()
    }
    afterEach {
      node = nil
    }

    describe("RegisterContainerNode") {

      context("레이아웃 호출 테스트") {
        beforeEach {
          _ = node.layoutSpecThatFits(
            .init(
              min: .init(width: 100, height: 100),
              max: .init(width: 200, height: 200)))
        }

        it("에러가 발생하지 않는다") {
          expect(node).toNot(beNil())
        }
      }

      context("입력 폼테스트") {

        context("이메일 비밀번호 이름 아이디에 빈값 입력시") {
          beforeEach {
            node.registerFormNode.emailInputNode.reactor?.action.onNext(.editingChanged(emailScope, nil))
            node.registerFormNode.passwordInputNode.reactor?.action.onNext(.editingChanged(passwordScope, nil))
            node.registerFormNode.fullNameInputNode.reactor?.action.onNext(.editingChanged(fullNameScope, nil))
            node.registerFormNode.usernameInputNode.reactor?.action.onNext(.editingChanged(userNameScope, nil))
          }

          it("회원가입 버튼은 비활성화 된다") {
            expect(node.registerFormNode.signUpButtonNode.isEnabled).toEventually(beFalse(), timeout: TestUtil.Const.timeout)
          }
        }

        context("이메일 비밀번호 이름 아이디가 정상적으로 입력시") {
          beforeEach {
            node.registerFormNode.emailInputNode.reactor?.action.onNext(.editingChanged(emailScope, "test@test.com"))
            node.registerFormNode.passwordInputNode.reactor?.action.onNext(.editingChanged(passwordScope, "1234567890"))
            node.registerFormNode.fullNameInputNode.reactor?.action.onNext(.editingChanged(fullNameScope, "fullName"))
            node.registerFormNode.usernameInputNode.reactor?.action.onNext(.editingChanged(userNameScope, "userName"))
          }

          it("회원가입 버튼은 활성화 된다") {
            expect(node.registerFormNode.signUpButtonNode.isEnabled).toEventually(beTrue(), timeout: TestUtil.Const.timeout)
          }
        }

        context("비밀번호 이름 아이디가 정상적으로 입력시") {
          beforeEach {

            node.registerFormNode.passwordInputNode.reactor?.action.onNext(.editingChanged(passwordScope, "1234567890"))
            node.registerFormNode.fullNameInputNode.reactor?.action.onNext(.editingChanged(fullNameScope, "fullName"))
            node.registerFormNode.usernameInputNode.reactor?.action.onNext(.editingChanged(userNameScope, "userName"))
          }

          context("잘못된 이메일 입력시") {
            beforeEach {
              node.registerFormNode.emailInputNode.reactor?.action.onNext(.editingChanged(emailScope, "test@teasdad"))
            }

            it("회원가입 버튼은 비활성화 된다") {
              expect(node.registerFormNode.signUpButtonNode.isEnabled).toEventually(beFalse(), timeout: TestUtil.Const.timeout)
            }
          }
        }

        context("이메일 이름 아이디가 정상적으로 입력시") {
          beforeEach {
            node.registerFormNode.emailInputNode.reactor?.action.onNext(.editingChanged(emailScope, "test@test.com"))
            node.registerFormNode.fullNameInputNode.reactor?.action.onNext(.editingChanged(fullNameScope, "fullName"))
            node.registerFormNode.usernameInputNode.reactor?.action.onNext(.editingChanged(userNameScope, "userName"))
          }

          context("비밀번호 4자리 입력시") {
            beforeEach {
              node.registerFormNode.passwordInputNode.reactor?.action.onNext(.editingChanged(passwordScope, "1234"))
            }

            it("회원가입 버튼은 비활성화 된다") {
              expect(node.registerFormNode.signUpButtonNode.isEnabled).toEventually(beFalse(), timeout: TestUtil.Const.timeout)
            }
          }
        }

        context("이메일 비밀번호 아이디가 정상적으로 입력시") {
          beforeEach {
            node.registerFormNode.emailInputNode.reactor?.action.onNext(.editingChanged(emailScope, "test@test.com"))
            node.registerFormNode.passwordInputNode.reactor?.action.onNext(.editingChanged(passwordScope, "1234567890"))
            node.registerFormNode.usernameInputNode.reactor?.action.onNext(.editingChanged(userNameScope, "userName"))
          }

          context("이름을 3자리 입력시") {
            beforeEach {
              node.registerFormNode.fullNameInputNode.reactor?.action.onNext(.editingChanged(fullNameScope, "123"))
            }

            it("회원가입 버튼은 비활성화 된다") {
              expect(node.registerFormNode.signUpButtonNode.isEnabled).toEventually(beFalse(), timeout: TestUtil.Const.timeout)
            }
          }
        }

        context("이메일 비밀번호 이름을 정상적으로 입력시") {
          beforeEach {
            node.registerFormNode.emailInputNode.reactor?.action.onNext(.editingChanged(emailScope, "test@test.com"))
            node.registerFormNode.passwordInputNode.reactor?.action.onNext(.editingChanged(passwordScope, "1234567890"))
            node.registerFormNode.fullNameInputNode.reactor?.action.onNext(.editingChanged(fullNameScope, "fullName"))
            node.registerFormNode.usernameInputNode.reactor?.action.onNext(.editingChanged(userNameScope, "userName"))
          }

          context("아이디를 3자리 입력시") {
            beforeEach {
              node.registerFormNode.usernameInputNode.reactor?.action.onNext(.editingChanged(userNameScope, "123"))
            }

            it("회원가입 버튼은 비활성화 된다") {
              expect(node.registerFormNode.signUpButtonNode.isEnabled).toEventually(beFalse(), timeout: TestUtil.Const.timeout)
            }
          }
        }
      }
    }
  }
}
