//
//  UIView+Animation.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 13.04.2025.
//

import UIKit

public extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration, animations: { self.alpha = 1 }) { _ in
            completion?()
        }
    }
    
    func fadeOut(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 0 }) { _ in
            self.isHidden = true
            completion?()
        }
    }
}
