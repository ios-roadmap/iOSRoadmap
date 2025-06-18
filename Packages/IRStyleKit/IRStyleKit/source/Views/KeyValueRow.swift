//
//  KeyValueRow.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 18.06.2025.
//

import UIKit

/// Görüntü / buton / metin gibi farklı tiplerde değer gösterebilen satır.
public final class KeyValueRowView: UIView {

    // MARK: - Public helpers

    public struct Model {
        let title: String
        let description: String?
        let value: Value
        
        public init(title: String, description: String?, value: Value) {
            self.title = title
            self.description = description
            self.value = value
        }
    }

    public enum Value {
        case text(String)
        case image(UIImage)
        case button(title: String, action: () -> Void)
    }

    public func apply(_ model: Model) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.description == nil
        configureRightStack(for: model.value)
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }

    // MARK: - Private UI

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.numberOfLines = 1
        return lbl
    }()

    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .preferredFont(forTextStyle: .footnote)
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()

    private lazy var leftStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .leading
        return sv
    }()

    private lazy var rightStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical      // tek öğe de olsa hizayı korur
        sv.alignment = .trailing
        return sv
    }()

    private lazy var rootStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [leftStack, rightStack])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 12
        return sv
    }()

    private func setUpViews() {
        addSubview(rootStack)
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            rootStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rootStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rootStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])

        // Sol taraf solda kalsın, sağ taraf sıkışabilsin:
        leftStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rightStack.setContentHuggingPriority(.required, for: .horizontal)
    }

    // MARK: - Right-side configuration

    private var actionHandler: (() -> Void)?

    private func configureRightStack(for value: Value) {
        rightStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        actionHandler = nil

        switch value {
        case .text(let text):
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .body)
            label.textAlignment = .right
            label.text = text
            rightStack.addArrangedSubview(label)

        case .image(let image):
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.setContentHuggingPriority(.required, for: .vertical)
            rightStack.addArrangedSubview(imageView)

        case .button(let title, let action):
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            actionHandler = action
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            rightStack.addArrangedSubview(button)
        }
    }

    @objc private func buttonTapped() {
        actionHandler?()
    }
}

