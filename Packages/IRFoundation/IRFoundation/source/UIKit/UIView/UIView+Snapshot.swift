//
//  UIView+Snapshot.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 29.04.2025.
//

import UIKit

/// Use cases:
/// - Create shareable visuals (cards, charts, certificates).
/// - Perform smooth animations using snapshots instead of heavy views.
/// - Display quick placeholders for unloaded content.
/// - Compare screenshots during UI testing.
/// - Animate custom transitions using a static copy of the view.
/// - Blur the screen when the app moves to background.
/// - Cache complex view hierarchies as images for performance gains.
private final class IRSnapshotView: UIImageView { }

public extension UIView {    
    /// Captures the current view hierarchy as a `UIImage`.
    var snapshotImage: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { [weak self] _ in
            guard let self else { return }
            self.drawHierarchy(in: bounds, afterScreenUpdates: false)
        }
    }
    
    /// Adds a snapshot of a given view to the current view with optional margins.
    /// - Parameters:
    ///   - view: The target view to snapshot.
    ///   - margin: Optional padding to expand the snapshot frame.
    /// - Returns: The snapshot `UIView` instance if successful, otherwise `nil`.
    @discardableResult
    func addSnapshot(of view: UIView, with margin: UIEdgeInsets? = nil) -> UIView? {
        guard let snapshot = view.snapshotImage,
              let globalPoint = view.superview?.convert(view.frame.origin, to: nil) else {
            return nil
        }

        var updatedPoint = globalPoint
        var updatedSize = view.frame.size
        
        if let margin {
            updatedPoint.x -= margin.left
            updatedPoint.y -= margin.top
            
            updatedSize.width += (margin.right + margin.left)
            updatedSize.height += (margin.top + margin.bottom)
        }
        
        let imageView = IRSnapshotView(image: snapshot)
        imageView.frame = CGRect(origin: updatedPoint, size: updatedSize)
        imageView.contentMode = .center
        imageView.backgroundColor = .yellow
        imageView.layer.cornerRadius = 6
        
        addSubviews(imageView)
        imageView.fadeIn()
        
        return imageView
    }
    
    /// Removes all snapshot views (`IRSnapshotView`) from the view with a fade-out animation.
    func removeSnapshots() {
        subviews
            .lazy
            .filter { $0 is IRSnapshotView }
            .forEach { snapshotView in
                snapshotView.fadeOut {
                    snapshotView.removeFromSuperview()
                }
            }
    }
}
