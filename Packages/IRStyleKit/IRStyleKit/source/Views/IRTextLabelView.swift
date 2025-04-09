//
//  IRTextLabelView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit

public final class IRTextLabelView: UIView {

    public lazy var textUILabel: UILabel = .init()

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        textUILabel.translatesAutoresizingMaskIntoConstraints = false
        textUILabel.textColor = .label
        addSubview(textUILabel)

        NSLayoutConstraint.activate([
            textUILabel.topAnchor.constraint(equalTo: topAnchor),
            textUILabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textUILabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textUILabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    public func configure(text: String) {
        textUILabel.text = text
    }
}
