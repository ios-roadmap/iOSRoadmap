//
//  Button.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit
import IRFoundation

//NOTE: Katmanlar
/// UIResponder: touchesBegan, touchesMoved gibi event'leri handle eder. UIApplication ve UIWindow'un bile Base'i
/// UIView: Görsel içerik gösterimi (çizim, layout, animasyon). CALayer backing ile çalışır.
/// UIControl: State yönetimi içerir (isEnabled, isSelected, isHighlighted).
/// UIResponder - UIView - UIControl - UIButton

// MARK: – Button
public final class Button: UIControl {

    // MARK: Stored state
    private var style     : ButtonStyle = .filledPrimary
    private var titleText : String?
    private var iconImage : UIImage?
    public  var tapHandler: VoidHandler?

    // MARK: Subviews
    private let titleLabel       = TextLabel()
    private let imageView        = ImageView()
    private let contentStack     = UIStackView()
    private let highlightOverlay = UIView()

    // MARK: Init
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: Private helpers
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        rebuild()
    }

    private func rebuild() {
        // ---- Container styling
        backgroundColor    = style.background
        layer.cornerRadius = style.cornerRadius
        layer.borderWidth  = style.border == nil ? 0 : 1
        layer.borderColor  = style.border?.cgColor

        // ---- Highlight overlay
        if highlightOverlay.superview == nil {
            highlightOverlay.isUserInteractionEnabled = false
            highlightOverlay.translatesAutoresizingMaskIntoConstraints = false
            addSubview(highlightOverlay)
            NSLayoutConstraint.activate([
                highlightOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
                highlightOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
                highlightOverlay.topAnchor.constraint(equalTo: topAnchor),
                highlightOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        highlightOverlay.backgroundColor = Colors.pressedOverlay
        highlightOverlay.layer.cornerRadius = style.cornerRadius

        // ---- Title / Icon
        titleLabel
            .withTransform(style.textTransform)
            .withTypography(style.typography)
            .withText(titleText)
            .withTextColor(style.foreground)

        imageView
            .withImage(iconImage?.withRenderingMode(.alwaysTemplate))
            .withTintColor(style.foreground)
            .withContentMode(.scaleAspectFit)
            .withUserInteraction(false)

        // ---- Content stack
        if contentStack.superview == nil {
            contentStack.translatesAutoresizingMaskIntoConstraints = false
            contentStack.isUserInteractionEnabled = false
            addSubview(contentStack)
            NSLayoutConstraint.activate([
                contentStack.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: Spacing.tiny.value),
                contentStack.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -Spacing.tiny.value),
                contentStack.topAnchor.constraint(equalTo: topAnchor),
                contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        contentStack.axis         = .horizontal
        contentStack.spacing      = style.spacing.value
        contentStack.alignment    = .center
        contentStack.distribution = .fill

        contentStack.arrangedSubviews.forEach {
            contentStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let hasIcon  = iconImage != nil
        let hasTitle = !(titleText?.isEmpty ?? true)

        switch style.iconAlignment {
        case .leading:
            if hasIcon  { contentStack.addArrangedSubview(imageView) }
            if hasTitle { contentStack.addArrangedSubview(titleLabel) }
        case .trailing:
            if hasTitle { contentStack.addArrangedSubview(titleLabel) }
            if hasIcon  { contentStack.addArrangedSubview(imageView) }
        }

        if !(constraints.contains { $0.firstAttribute == .height }) {
            heightAnchor.constraint(equalToConstant: style.height).isActive = true
        }
    }

    // MARK: Interaction
    // TODO: ömer - Hatalı çalışyor. İlgileceneğim.
//    public override var isHighlighted: Bool {
//        didSet {
//            UIView.animate(withDuration: 0.12,
//                           delay: 0,
//                           options: [.allowUserInteraction, .curveEaseInOut]) {
//                self.highlightOverlay.alpha = self.isHighlighted ? 1 : 0
//            }
//        }
//    }

    @objc private func tapped() { tapHandler?() }
}

// MARK: – Builder API
public extension Button {

    @discardableResult
    func withStyle(_ style: ButtonStyle) -> Self {
        self.style = style
        rebuild()
        return self
    }

    @discardableResult
    func withTitle(_ title: String?) -> Self {
        titleText = title
        rebuild()
        return self
    }

    @discardableResult
    func withIcon(_ image: UIImage?) -> Self {
        iconImage = image
        rebuild()
        return self
    }

    @discardableResult
    func withAction(_ handler: VoidHandler?) -> Self {
        tapHandler = handler
        return self
    }
    
    @discardableResult
    func withTag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
}
