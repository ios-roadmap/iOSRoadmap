//
//  UIView.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import UIKit

public extension UIView {

    @discardableResult
    func withSize(width: CGFloat, height: CGFloat? = nil) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height ?? width) // square
        ])
        return self
    }

    @discardableResult
    func withContentHugging(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentHuggingPriority(priority, for: axis)
        return self
    }

    @discardableResult
    func withCompressionResistance(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
}
