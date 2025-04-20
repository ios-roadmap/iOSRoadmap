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

    // MARK: - Public API
    public var tapHandler: VoidHandler?

    // MARK: - Subviews
    private let titleLabel       = TextLabel()
    private let imageView        = UIImageView()
    private let contentStack     = UIStackView()
    //TODO: bunlar ayrı component'ler olacak!
    private let highlightOverlay = UIView()

    // MARK: - Init
    public init(style: ButtonStyle,
                title: String? = nil,
                icon: UIImage? = nil,
                tapHandler: VoidHandler? = nil) {
        self.tapHandler = tapHandler
        super.init(frame: .zero)

        configure(style: style, title: title, icon: icon)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Configure
    private func configure(style: ButtonStyle,
                           title: String?,
                           icon: UIImage?) {
        isUserInteractionEnabled = true
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        // ---- Background & Border
        backgroundColor = style.background
               layer.cornerRadius = style.cornerRadius
               layer.borderWidth  = style.border == nil ? 0 : 1
               layer.borderColor  = style.border?.cgColor

        // ---- Highlight Layer
        // Highlight overlay now uses token
               highlightOverlay.backgroundColor = Colors.pressedOverlay
               highlightOverlay.layer.cornerRadius = style.cornerRadius
        highlightOverlay.isUserInteractionEnabled = false
        highlightOverlay.translatesAutoresizingMaskIntoConstraints = false
        highlightOverlay.alpha = 0

        addSubview(highlightOverlay)

        NSLayoutConstraint.activate([
            highlightOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            highlightOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            highlightOverlay.topAnchor.constraint(equalTo: topAnchor),
            highlightOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // ---- Title Label
        titleLabel.withTransform(style.textTransform)
                  .withText(title)
                  .withTypography(style.typography)
                  .withTextColor(style.foreground)
        titleLabel.isUserInteractionEnabled = false

        // ---- Icon
        imageView.image       = icon?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor   = style.foreground
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false

        // ---- Content Stack
        contentStack.axis         = .horizontal
        contentStack.spacing      = style.spacing.value
        contentStack.alignment    = .center
        contentStack.distribution = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isUserInteractionEnabled = false

        contentStack.arrangedSubviews.forEach { view in
            contentStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        let hasIcon  = icon != nil
        let hasTitle = !(title?.isEmpty ?? true)

        switch style.iconAlignment {
        case .leading:
            if hasIcon  { contentStack.addArrangedSubview(imageView) }
            if hasTitle { contentStack.addArrangedSubview(titleLabel) }
        case .trailing:
            if hasTitle { contentStack.addArrangedSubview(titleLabel) }
            if hasIcon  { contentStack.addArrangedSubview(imageView) }
        }

        addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.tiny.value),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.tiny.value),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(equalToConstant: style.height)
        ])
    }

    // MARK: - Interaction
    public override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.12,
                           delay: 0,
                           options: [.allowUserInteraction, .curveEaseInOut]) {
                self.highlightOverlay.alpha = self.isHighlighted ? 1 : 0
            }
        }
    }

    @objc private func tapped() {
        tapHandler?()
    }
}
