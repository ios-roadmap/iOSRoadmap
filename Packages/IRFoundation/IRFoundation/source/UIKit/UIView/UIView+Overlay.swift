//
//  UIView+Overlay.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 29.04.2025.
//

import UIKit

private final class IRDarkOverlayView: UIView { }

public extension UIView {
    
    /// Adds a dark overlay on top of the view with a fade-in animation.
    /// - Parameter completion: An optional closure executed after the fade-in completes.
    func addDarkOverlay(completion: (() -> Void)? = nil) {
        removeDarkOverlay()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let overlay = IRDarkOverlayView(frame: bounds)
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            
            fit(overlay)
            overlay.fadeIn(completion: completion)
        }
    }
    
    /// Removes the dark overlay from the view with a fade-out animation.
    func removeDarkOverlay() {
        DispatchQueue.main.async { [weak self] in
            self?.subviews.compactMap { $0 as? IRDarkOverlayView }.forEach { overlay in
                overlay.fadeOut {
                    overlay.removeFromSuperview()
                }
            }
        }
    }
}
