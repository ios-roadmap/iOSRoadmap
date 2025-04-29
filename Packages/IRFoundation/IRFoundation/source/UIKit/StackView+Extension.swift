//
//  StackView+Extension.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 29.04.2025.
//

import UIKit

public extension UIStackView {
    /// Adds multiple views to the stack as arranged subviews in a single call.
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
