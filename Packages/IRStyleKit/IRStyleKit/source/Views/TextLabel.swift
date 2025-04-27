//
//  UILabel.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import UIKit
import IRFoundation

// MARK: - TextLabel
public final class TextLabel: UILabel {
    
    // MARK: Stored state
    private var typography     : Typography    = .body(.regular)
    private var transformRule  : TextTransform = .none
    private var userPadding    : UIEdgeInsets  = .zero
    private var borderPadding  : CGFloat       = .zero
    private var cachedText     : String?

    // MARK: Border
    public enum Shape { case circle, rectangle }

    private var shape   : Shape   = .rectangle
    private var bColour : UIColor = .clear
    private var bWidth  : CGFloat = .zero

    private lazy var decoration: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = false
        return v
    }()

    // MARK: Init
    public override init(frame: CGRect = .zero) { super.init(frame: frame); configure() }
    public required init?(coder: NSCoder)      { super.init(coder: coder); configure() }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        clipsToBounds = false
    }

    // MARK: Layout
    public override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets(
            top:    userPadding.top    + borderPadding,
            left:   userPadding.left   + borderPadding,
            bottom: userPadding.bottom + borderPadding,
            right:  userPadding.right  + borderPadding
        )
        super.drawText(in: rect.inset(by: inset))
    }

    public override var intrinsicContentSize: CGSize {
        let base = super.intrinsicContentSize
        let hPad = userPadding.left + userPadding.right + borderPadding * 2
        let vPad = userPadding.top  + userPadding.bottom + borderPadding * 2
        return CGSize(width: base.width + hPad, height: base.height + vPad)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard bWidth > .ulpOfOne else { return }

        decoration.layer.borderWidth   = bWidth
        decoration.layer.borderColor   = bColour.cgColor
        decoration.layer.masksToBounds = true
        decoration.layer.cornerRadius  = shape == .circle
                                       ? min(bounds.width, bounds.height) / 2
                                       : 0
    }
}

// MARK: - Builder API
public extension TextLabel {

    @discardableResult
    func withTypography(_ style: Typography) -> Self {
        typography = style
        font = style.font()
        return self
    }

    @discardableResult
    func withText(_ value: String?) -> Self {
        cachedText = value
        text = value.map { transformRule.apply(to: $0) }
        return self
    }

    @discardableResult
    func withTransform(_ rule: TextTransform) -> Self {
        transformRule = rule
        text = cachedText.map { rule.apply(to: $0) }
        return self
    }

    @discardableResult
    func withPadding(_ spacing: Spacing) -> Self {
        userPadding = .init(
            top: spacing.value,
            left: spacing.value,
            bottom: spacing.value,
            right: spacing.value
        )
        setNeedsDisplay()
        invalidateIntrinsicContentSize()
        return self
    }

    @discardableResult
    func withTextColor(_ colour: UIColor) -> Self {
        textColor = colour; return self
    }

    @discardableResult
    func withLines(_ n: Int) -> Self {
        numberOfLines = n; return self
    }

    @discardableResult
    func withAlignment(_ a: NSTextAlignment) -> Self {
        textAlignment = a; return self
    }

    @discardableResult
    func withBorder(
        _ shape: Shape,
        colour: UIColor,
        width: CGFloat = 1.0
    ) -> Self {
        self.shape  = shape
        bColour     = colour
        bWidth      = width
        borderPadding = width + 4

        if decoration.superview == nil {
            insertSubview(decoration, at: 0)
            NSLayoutConstraint.activate([
                decoration.topAnchor.constraint(equalTo: topAnchor),
                decoration.leadingAnchor.constraint(equalTo: leadingAnchor),
                decoration.trailingAnchor.constraint(equalTo: trailingAnchor),
                decoration.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        setNeedsLayout()
        invalidateIntrinsicContentSize()
        return self
    }
}

//TODO: Swiftlint
///UIColor direkt kullanmak YASAK!
///Swiftlint ile kontrol sağlanacak.
