//
//  UIView+Animation.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 29.04.2025.
//

import UIKit

import UIKit

public extension UIView {
    
    /// Animates the view to fade in by changing its alpha from 0 to 1.
    func fadeIn(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration, animations: { self.alpha = 1 }) { _ in
            completion?()
        }
    }
    
    /// Animates the view to fade out by changing its alpha from 1 to 0, then hides it.
    func fadeOut(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 0 }) { [weak self] _ in
            self?.isHidden = true
            completion?()
        }
    }
}
