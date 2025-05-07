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

private final class IRSnapshotView: UIImageView {}

public extension UIView {

    func snapshotImage(
        trim: UIEdgeInsets = .zero,
        expand: UIEdgeInsets = .zero
    ) -> UIImage? {
        guard bounds.width > 0, bounds.height > 0 else { return nil }

        let expandedSize = CGSize(
            width: bounds.width + expand.left + expand.right,
            height: bounds.height + expand.top + expand.bottom
        )

        let format = UIGraphicsImageRendererFormat(for: traitCollection)
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: expandedSize, format: format)

        return renderer.image { _ in
            let origin = CGPoint(x: expand.left, y: expand.top)
            drawHierarchy(in: CGRect(origin: origin, size: bounds.size), afterScreenUpdates: false)
        }.cropped(by: trim)
    }

    @discardableResult
    func addSnapshot(
        of view: UIView,
        margin: UIEdgeInsets? = nil,
        crop rc: UIEdgeInsets? = nil
    ) -> UIView? {
        let rc = rc ?? .zero

        let trim = UIEdgeInsets(
            top:    max(-rc.top,    0),
            left:   max(-rc.left,   0),
            bottom: max(-rc.bottom, 0),
            right:  max(-rc.right,  0)
        )
        let expand = UIEdgeInsets(
            top:    max(rc.top,    0),
            left:   max(rc.left,   0),
            bottom: max(rc.bottom, 0),
            right:  max(rc.right,  0)
        )

        guard let image = view.snapshotImage(trim: trim, expand: expand),
              let superOrigin = view.superview?.convert(view.frame.origin, to: self)
        else { return nil }

        let m = margin ?? .zero
        let origin = CGPoint(
            x: superOrigin.x + trim.left - m.left - expand.left,
            y: superOrigin.y + trim.top  - m.top  - expand.top
        )

        let size = CGSize(
            width:  view.bounds.width  - trim.left - trim.right
                  + m.left + m.right + expand.left + expand.right,
            height: view.bounds.height - trim.top  - trim.bottom
                  + m.top  + m.bottom + expand.top + expand.bottom
        )

        let iv = IRSnapshotView(image: image)
        iv.frame = CGRect(origin: origin, size: size)
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 6
        iv.clipsToBounds = true

        addSubviews(iv)
        iv.fadeIn()
        return iv
    }

    /// Removes all `IRSnapshotView`s from the receiver with a fade‑out animation.
    func removeSnapshots() {
        subviews
            .lazy
            .compactMap { $0 as? IRSnapshotView }
            .forEach { snapshot in
                snapshot.fadeOut { snapshot.removeFromSuperview() }
            }
    }
}

// MARK: - UIImage Cropping Extension

private extension UIImage {
    /// Returns a new image cropped by the supplied **positive** insets (points).
    /// Negative insets **expand** the canvas.
    func cropped(by insets: UIEdgeInsets) -> UIImage? {
        guard insets != .zero else { return self }

        let newSize = CGSize(
            width:  size.width  - insets.left - insets.right,
            height: size.height - insets.top  - insets.bottom
        )
        guard newSize.width > 0, newSize.height > 0 else { return nil }

        let format = imageRendererFormat
        return UIGraphicsImageRenderer(size: newSize, format: format).image { _ in
            draw(at: CGPoint(x: -insets.left, y: -insets.top))
        }
    }
}
