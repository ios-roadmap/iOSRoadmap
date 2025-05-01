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

public final class Button: UIButton {

    // MARK: Stored state -------------------------------------------------------

    private var style: ButtonStyle = .filled
    private var tapHandler: VoidHandler?
    private var heightConstraint: NSLayoutConstraint?

    // MARK: Init ---------------------------------------------------------------

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        disableDefaultConfiguration()
        rebuild()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    // MARK: Private ------------------------------------------------------------

    private func disableDefaultConfiguration() {
        if #available(iOS 15.0, *) {
            self.configuration = nil
            self.configurationUpdateHandler = nil
        }
    }

    private func rebuild() {
        // Typography & Text
        titleLabel?.font = style.typography.font()
        if let txt = currentTitle {
            setTitle(style.textTransform.apply(to: txt), for: .normal)
        }

        // Colour
        backgroundColor = style.background
        setTitleColor(style.foreground, for: .normal)
        tintColor = style.foreground

        // Border & Corner
        layer.borderWidth  = style.border == nil ? 0 : 1
        layer.borderColor  = style.border?.cgColor
        layer.cornerRadius = style.cornerRadius
        clipsToBounds      = style.cornerRadius > 0

        // Height
        if heightConstraint == nil {
            heightConstraint = heightAnchor.constraint(equalToConstant: style.height)
            heightConstraint?.isActive = true
        } else {
            heightConstraint?.constant = style.height
        }

        configureInsets()
        imageView?.contentMode = .scaleAspectFit
    }

    private func configureInsets() {
        let gap = style.spacing.value
        semanticContentAttribute = style.iconAlignment == .trailing ? .forceRightToLeft : .forceLeftToRight

        // Applies spacing correctly for both icon positions
        if style.iconAlignment == .trailing {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -gap / 2, bottom: 0, right: gap / 2)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: gap / 2, bottom: 0, right: -gap / 2)
        } else {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: gap / 2, bottom: 0, right: -gap / 2)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -gap / 2, bottom: 0, right: gap / 2)
        }

        contentEdgeInsets = UIEdgeInsets(top: 0, left: gap, bottom: 0, right: gap)
    }

    @objc private func tapped() {
        tapHandler?()
    }
}

// MARK: Builder API -----------------------------------------------------------

public extension Button {

    @discardableResult
    func withStyle(_ style: ButtonStyle) -> Self {
        self.style = style
        rebuild()
        return self
    }

    @discardableResult
    func withTitle(_ title: String?) -> Self {
        setTitle(title, for: .normal)
        rebuild()
        return self
    }

    @discardableResult
    func withIcon(_ image: UIImage?) -> Self {
        setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
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
