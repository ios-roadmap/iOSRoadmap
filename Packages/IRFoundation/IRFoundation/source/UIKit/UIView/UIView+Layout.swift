//
//  UIView+Layout.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import UIKit

public extension UIView {

    /// Sets explicit width and height constraints for the view.
    @discardableResult
    func withSize(width: CGFloat, height: CGFloat? = nil) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height ?? width)
        ])
        return self
    }

    /// Sets the content hugging priority for the specified axis.
    /// - Parameters:
    ///   - priority: The hugging priority value to apply.
    ///   - axis: The axis (horizontal or vertical) to apply the priority on.
    /// - Returns: The view itself for chaining.
    @discardableResult
    func withContentHugging(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentHuggingPriority(priority, for: axis)
        return self
    }

    /// Sets the content compression resistance priority for the specified axis.
    @discardableResult
    func withCompressionResistance(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
    
    /// Pins the view's edges (top, bottom, leading, trailing) to match the given view's edges.
    func pinEdges(to other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor),
            topAnchor.constraint(equalTo: other.topAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor)
        ])
    }
}
