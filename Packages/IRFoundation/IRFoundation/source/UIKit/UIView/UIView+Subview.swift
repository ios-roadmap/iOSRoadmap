//
//  UIView+Subview.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 29.04.2025.
//

import UIKit

public extension UIView {
    /// Adds multiple subviews to the view in a single call.
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    enum FitOrientation { case horizontal, vertical, both }
    
    /// Pins `subview` to the receiver’s edges, with optional padding.
    @discardableResult
    func fit(
        _ subview: UIView,
        orientation: FitOrientation = .both,
        padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        
        if subview.superview !== self { addSubview(subview) }
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if orientation != .vertical {
            constraints += [
                subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)
            ]
        }
        if orientation != .horizontal {
            constraints += [
                subview.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
            ]
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
