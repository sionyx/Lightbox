import UIKit

protocol HeaderViewDelegate: class {
  func headerView(_ headerView: HeaderView, didPressDeleteButton deleteButton: UIButton)
  func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
  func headerView(_ headerView: HeaderView, didPressCustomButton customButton: UIButton)
}

open class HeaderView: UIView {
  open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.CloseButton.text,
      attributes: LightboxConfig.CloseButton.textAttributes)

    let button = UIButton(type: .system)

    button.setAttributedTitle(title, for: UIControl.State())

    if let size = LightboxConfig.CloseButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(closeButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = LightboxConfig.CloseButton.image {
      button.setBackgroundImage(image, for: UIControl.State())
    }

    if let tintColor = LightboxConfig.CloseButton.tintColor {
      button.tintColor = tintColor
    }

    button.isHidden = !LightboxConfig.CloseButton.enabled

    return button
  }()

  open fileprivate(set) lazy var deleteButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.DeleteButton.text,
      attributes: LightboxConfig.DeleteButton.textAttributes)

    let button = UIButton(type: .system)

    button.setAttributedTitle(title, for: .normal)

    if let size = LightboxConfig.DeleteButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(deleteButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = LightboxConfig.DeleteButton.image {
      button.setBackgroundImage(image, for: UIControl.State())
    }

    if let tintColor = LightboxConfig.DeleteButton.tintColor {
      button.tintColor = tintColor
    }

    button.isHidden = !LightboxConfig.DeleteButton.enabled

    return button
  }()

  open fileprivate(set) lazy var customButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.CustomButton.text,
      attributes: LightboxConfig.CustomButton.textAttributes)

      let button = UIButton(type: .system)
      button.contentMode = .center

      button.setAttributedTitle(title, for: .normal)

      if let size = LightboxConfig.CustomButton.size {
        button.frame.size = size
      } else {
        button.sizeToFit()
      }

      button.addTarget(self, action: #selector(customButtonDidPress(_:)),
        for: .touchUpInside)

      if let image = LightboxConfig.CustomButton.image {
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
      }

      if let tintColor = LightboxConfig.CustomButton.tintColor {
        button.tintColor = tintColor
      }

      button.isHidden = !LightboxConfig.CustomButton.enabled

      return button
  }()

  weak var delegate: HeaderViewDelegate?

  // MARK: - Initializers

  public init() {
    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear

    [closeButton, deleteButton, customButton].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func deleteButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressDeleteButton: button)
  }

  @objc func closeButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressCloseButton: button)
  }

  @objc func customButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressCustomButton: button)
  }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {

  @objc public func configureLayout() {
    let sidePadding: CGFloat = 17
    let topPadding: CGFloat

    if #available(iOS 11, *) {
      topPadding = safeAreaInsets.top
    } else {
      topPadding = 0
    }

    closeButton.frame.origin = CGPoint(
      x: (LightboxConfig.CloseButton.position == .left) ? sidePadding : bounds.width - closeButton.frame.width - sidePadding,
      y: topPadding
    )

    deleteButton.frame.origin = CGPoint(
      x: (LightboxConfig.DeleteButton.position == .left) ? sidePadding : bounds.width - deleteButton.frame.width - sidePadding,
      y: topPadding
    )

    customButton.frame.origin = CGPoint(
      x: (LightboxConfig.CustomButton.position == .left) ? sidePadding : bounds.width - customButton.frame.width - sidePadding,
      y: topPadding
    )
  }
}
