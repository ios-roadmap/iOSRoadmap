//
//  UILabel.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import UIKit
import IRFoundation

public final class TextLabel: UILabel {

    private var fontType: FontType = .regular
    private var fontSize: FontSize = .body
    private var textTransform: TextTransform = .none
    private var padding: UIEdgeInsets = .zero
    private var dynamicTypeEnabled: Bool = true
    private var originalText: String?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
    }

    private func updateFont() {
        let style = dynamicTypeEnabled ? fontSize.textStyle : nil
        font = fontType.font(ofSize: fontSize.pointSize, textStyle: style)
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

extension TextLabel {
    @discardableResult
    public func withFont(_ type: FontType, size: FontSize) -> Self {
        fontType = type
        fontSize = size
        updateFont()
        return self
    }

    @discardableResult
    public func withText(_ text: String?) -> Self {
        originalText = text
        self.text = text.map { textTransform.apply(to: $0) }
        return self
    }

    @discardableResult
    public func withTransform(_ transform: TextTransform) -> Self {
        textTransform = transform
        self.text = originalText.map { transform.apply(to: $0) }
        return self
    }

    @discardableResult
    public func withPadding(_ spacing: Spacing) -> Self {
        padding = .init(top: spacing.value, left: spacing.value, bottom: spacing.value, right: spacing.value)
        setNeedsDisplay()
        return self
    }

    @discardableResult
    public func withColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }

    @discardableResult
    public func withLines(_ count: Int) -> Self {
        numberOfLines = count
        return self
    }

    @discardableResult
    public func withAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }

    @discardableResult
    public func withDynamicType(_ enabled: Bool) -> Self {
        dynamicTypeEnabled = enabled
        updateFont()
        return self
    }
}

//TODO: Swiftlint
///UIColor direkt kullanmak YASAK!
///Swiftlint ile kontrol sağlanacak.
