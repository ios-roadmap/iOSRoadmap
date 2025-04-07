//
//  IRSpacerView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit

public final class IRSpacerView: UIView {

    private var heightConstraint: NSLayoutConstraint!

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        configure(height: 0, backgroundColor: nil)
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
    }

    public func configure(height: CGFloat, backgroundColor: UIColor? = nil) {
        heightConstraint.constant = height
        self.backgroundColor = backgroundColor
    }
}
