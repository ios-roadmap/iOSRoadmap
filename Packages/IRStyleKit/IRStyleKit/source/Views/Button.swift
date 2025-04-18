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

    public init(style: ButtonStyle,
                title: String,
                icon: Icons = .none) {
        super.init(frame: .zero)

        let font = style.fontType
            .font(ofSize: style.fontSize.pointSize,
                  textStyle: style.fontSize.textStyle)
        let transformedTitle = style.textTransform.apply(to: title)

        setTitle(transformedTitle, for: .normal)
        titleLabel?.font = font

        backgroundColor = UIColor(named: style.backgroundToken)
        setTitleColor(UIColor(named: style.titleToken), for: .normal)

        if let border = style.borderToken {
            layer.borderColor = UIColor(named: border)?.cgColor
            layer.borderWidth = 1 / UIScreen.main.scale
        }

        // Eğer icon varsa ekle
        if let image = UIImage(systemName: "person") {//icon.rawV) {
            setImage(image, for: .normal)
            imageView?.contentMode = .scaleAspectFit
            semanticContentAttribute = style.iconAlignment == .leading ? .forceLeftToRight : .forceRightToLeft
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        }

        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layer.cornerRadius = 7 //style.cornerRadius
        clipsToBounds = true

        heightAnchor.constraint(equalToConstant: style.height).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init(coder: NSCoder) {
        fatalError()
    }
}
