import AsyncDisplayKit

// MARK: - RegisterFormNode

final class RegisterFormNode: ASScrollNode {

  // MARK: Lifecycle

  override init() {
    super.init()
    automaticallyManagesContentSize = true
    automaticallyManagesSubnodes = true
    backgroundColor = .clear
  }

  deinit {
    print("RegisterFormNode deinit...")
  }

  // MARK: Internal

  let plusButtonNode: ASButtonNode = {
    let node = ASButtonNode()
    node.setImage(#imageLiteral(resourceName: "register-photo"), for: .normal)
    node.tintColor = Const.plusButtonTintColor
    node.style.preferredSize = Const.plusButtonSize
    node.cornerRadius = Const.plusButtonSize.width / 2
    node.borderWidth = 1
    node.borderColor = Const.plusButtonTintColor.cgColor
    node.clipsToBounds = true
    return node
  }()

  let emailInputNode: FormTextInputNode = FormTextInputNode(scope: .email)
  let passwordInputNode = FormTextInputNode(scope: .password)
  let fullNameInputNode = FormTextInputNode(scope: .plain(placeholderString: "Fullname"))
  let usernameInputNode = FormTextInputNode(scope: .plain(placeholderString: "Username"))
  let signUpButtonNode = FormPrimaryButtonNode(type: .signUp)
  let keyboardDismissEventNode = ASControlNode()

  // MARK: Private

  private struct Const {
    static let plusButtonTintColor = UIColor.white
    static let plusButtonSize = CGSize(width: 120, height: 120)
    static let plusPadding = UIEdgeInsets(top: 00, left: 0, bottom: 20, right: 0)
    static let inputFieldSpacing: CGFloat = 20.0
    static let containerPadding =
      UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 30.0)
  }

}

extension RegisterFormNode {

  // MARK: Internal

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let contentsLayout = ASStackLayoutSpec(
      direction: .vertical,
      spacing: .zero,
      justifyContent: .start,
      alignItems: .stretch,
      children: [
        plusButtonAreaLayoutSpec(),
        inputFieldAreaLayoutSpec(),
      ])

    return ASOverlayLayoutSpec(
      child: keyboardDismissEventNode,
      overlay: contentsLayout)
  }

  // MARK: Private

  private func inputFieldAreaLayoutSpec() -> ASLayoutSpec {
    ASStackLayoutSpec(
      direction: .vertical,
      spacing: Const.inputFieldSpacing,
      justifyContent: .start,
      alignItems: .stretch,
      children: [
        emailInputNode,
        passwordInputNode,
        fullNameInputNode,
        usernameInputNode,
        signUpButtonNode,
      ])
  }

  private func plusButtonAreaLayoutSpec() -> ASLayoutSpec {
    let stackLayout = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: .zero,
      justifyContent: .center,
      alignItems: .stretch,
      children: [plusButtonNode])

    return ASInsetLayoutSpec(
      insets: Const.plusPadding,
      child: stackLayout)
  }
}
