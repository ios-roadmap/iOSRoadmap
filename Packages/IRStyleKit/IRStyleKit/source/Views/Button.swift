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

public final class Button: UIControl {

    private let label = UILabel()
    private let iconView = UIImageView()
    private let stackView = UIStackView()
    private let container = UIView()

    private let style: ButtonStyle
    private var action: (() -> Void)?

    public init(style: ButtonStyle) {
        self.style = style
        super.init(frame: .zero)
        setup()
        applyStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func withTitle(_ text: String) -> Self {
        label.text = text
        return self
    }

    @discardableResult
    public func withIcon(_ image: UIImage?) -> Self {
        iconView.image = image
        updateStackAlignment()
        return self
    }

    @discardableResult
    public func withAction(_ callback: @escaping () -> Void) -> Self {
        action = callback
        return self
    }

    private func setup() {
        isUserInteractionEnabled = true
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        container.isUserInteractionEnabled = false

        container.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = style.spacing.value
        stackView.isUserInteractionEnabled = false

        label.numberOfLines = 1
        iconView.contentMode = .scaleAspectFit

        addTarget(self, action: #selector(didTap), for: .touchUpInside)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: style.padding.left),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -style.padding.right),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: style.padding.top),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -style.padding.bottom),
            heightAnchor.constraint(equalToConstant: style.height)
        ])
    }

    private func applyStyle() {
        container.backgroundColor = .yellow
        container.layer.cornerRadius = style.cornerRadius.value

        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: style.fontSize.pointSize)

        iconView.tintColor = .black

        if style.hasText { stackView.addArrangedSubview(label) }
        if style.hasIcon { stackView.addArrangedSubview(iconView) }

        updateStackAlignment()
    }

    private func updateStackAlignment() {
        guard style.hasText && style.hasIcon else { return }

        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        switch style.iconAlignment {
        case .leading:
            stackView.addArrangedSubview(iconView)
            stackView.addArrangedSubview(label)
        case .trailing:
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(iconView)
        }
    }

    @objc private func didTap() {
        action?()
    }
}
