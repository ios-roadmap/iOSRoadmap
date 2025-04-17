//
//  KeyValueView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import UIKit

public final class KeyValueView: UIStackView {

    public init(keyLabel: TextLabel, valueLabel: TextLabel) {
        super.init(frame: .zero)
        setupView(keyLabel: keyLabel, valueLabel: valueLabel)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(keyLabel: TextLabel, valueLabel: TextLabel) {
        axis = .horizontal
        alignment = .fill
        addArrangedSubview(keyLabel)
        addArrangedSubview(UIView.spacer())
        addArrangedSubview(valueLabel)
    }
}

private extension UIView {
    static func spacer() -> UIView {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return spacer
    }
}
