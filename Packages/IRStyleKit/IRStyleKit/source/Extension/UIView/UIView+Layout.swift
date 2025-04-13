//
//  UIView+Layout.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 13.04.2025.
//

import UIKit

public extension UIView {
    
    enum FitOrientation {
        case horizontal, vertical, both
    }

    @discardableResult
    func fit(
        subView view: UIView,
        orientated orientation: FitOrientation = .both,
        withPadding padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        if view.superview != self {
            addSubview(view)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        if orientation != .vertical {
            constraints += [
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)
            ]
        }
        
        if orientation != .horizontal {
            constraints += [
                view.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
            ]
        }
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
