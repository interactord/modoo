import AsyncDisplayKit

// MARK: - LoginContainerNode

final class LoginContainerNode: ASDisplayNode {

  // MARK: Lifecycle

  override init() {
    super.init()
    automaticallyManagesSubnodes = true
    automaticallyRelayoutOnSafeAreaChanges = true
    backgroundColor = .systemPink
  }

  // MARK: Internal

  struct Const {
    static let gradientStartColor = UIColor.systemPurple.cgColor
    static let gradientEndColor = UIColor.systemBlue.cgColor
    static let logoTintColor = UIColor.white
    static let layoutContentPadding = UIEdgeInsets(top: 100, left: 30, bottom: 0, right: 30)
    static let logoSize = CGSize(width: 220, height: 80)
  }

  override func layoutDidFinish() {
    super.layoutDidFinish()
    backgroundNode
      .gradientBackgroundColor(
        colors:
        [
          Const.gradientStartColor,
          Const.gradientEndColor,
        ],
        direction: .vertical)
  }

  // MARK: Private

  private var backgroundNode = ASDisplayNode()

  private lazy var logoNode: ASImageNode = {
    let node = ASImageNode()
    node.image = #imageLiteral(resourceName: "instargram-logo")
    node.tintColor = Const.logoTintColor
    node.contentMode = .scaleAspectFit
    node.style.preferredSize = Const.logoSize
    return node
  }()

  private lazy var emailInputNode: FormInputNode = {
    let node = FormInputNode(placeholderText: "Email", keyboardType: .emailAddress)
    node.style.preferredLayoutSize = .init(
      width: .init(unit: .fraction, value: 1),
      height: .init(unit: .points, value: 50))
    return node
  }()

  private lazy var passwordInputNode: FormInputNode = {
    let node = FormInputNode(placeholderText: "Password", isSecureTextEntry: false)
    node.style.preferredLayoutSize = .init(
      width: .init(unit: .fraction, value: 1),
      height: .init(unit: .points, value: 50))
    return node
  }()

  private lazy var loginButton: FormPrimaryButtonNode = {
    let node = FormPrimaryButtonNode(title: "Log in")
    node.style.preferredLayoutSize = .init(
      width: .init(unit: .fraction, value: 1),
      height: .init(unit: .points, value: 50))
    return node
  }()

  private lazy var forgetPasswordButton: FormSecondaryButtonNode = {
    let node = FormSecondaryButtonNode(
      firstPart: "Forget your password?",
      secondPart: "Get help signing in.")
    return node
  }()

  private lazy var dontHaveAccountButton: FormSecondaryButtonNode = {
    let node = FormSecondaryButtonNode(
      firstPart: "Don't have account?",
      secondPart: "Register")
    return node
  }()

}

// MARK: - LayoutSpec
extension LoginContainerNode {

  // MARK: Internal

  override func layoutSpecThatFits(_ constrainedSize: AsyncDisplayKit.ASSizeRange) -> ASLayoutSpec {
    let contentLayout = ASStackLayoutSpec(
      direction: .vertical,
      spacing: .zero,
      justifyContent: .spaceBetween,
      alignItems: .center,
      children: [headerContentLayoutSpec(), dontHaveAccountButton])
    let contentLayoutWithPadding = ASInsetLayoutSpec(
      insets: .merge(list: [Const.layoutContentPadding, safeAreaInsets]),
      child: contentLayout)
    return ASBackgroundLayoutSpec(child: contentLayoutWithPadding, background: backgroundNode)
  }

  // MARK: Private

  private func headerContentLayoutSpec() -> ASLayoutSpec {
    ASStackLayoutSpec(
      direction: .vertical,
      spacing: 32,
      justifyContent: .start,
      alignItems: .center,
      children: [logoNode, formGroupLayoutSpec()])
  }

  private func formGroupLayoutSpec() -> ASLayoutSpec {
    let elements = [emailInputNode, passwordInputNode, loginButton, forgetPasswordButton]
    let formGroupLayout = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 20,
      justifyContent: .start,
      alignItems: .stretch,
      children: elements)
    return formGroupLayout
  }
}