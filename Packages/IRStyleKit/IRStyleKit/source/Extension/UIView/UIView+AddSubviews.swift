//
//  UIView+AddSubviews.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 13.04.2025.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

//TODO: ömer extension file
public extension UIStackView {
    /// Adds multiple views to the stack as arranged subviews in a single call.
    ///
    /// - Parameter views: The views to be added.
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
