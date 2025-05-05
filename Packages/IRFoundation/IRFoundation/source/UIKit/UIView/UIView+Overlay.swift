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
        guard let container = window ?? (UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow })
        else { return }
        
        container.removeDarkOverlay()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let overlay = IRDarkOverlayView(frame: container.bounds)
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            overlay.translatesAutoresizingMaskIntoConstraints = false

//            // 👉 Insert at z‑index 0 so *every* subsequent subview (e.g. coachmark) sits above it.
//            container.insertSubview(overlay, at: 0)
            container.fit(overlay)

            overlay.fadeIn(completion: completion)
        }
    }
    
    /// Removes the dark overlay from the view with a fade-out animation.
    func removeDarkOverlay() {
        guard let container = window ?? (UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow })
        else { return }
        
        DispatchQueue.main.async { [weak self] in
            container.subviews.compactMap { $0 as? IRDarkOverlayView }.forEach { overlay in
                overlay.fadeOut {
                    overlay.removeFromSuperview()
                }
            }
        }
    }
}
