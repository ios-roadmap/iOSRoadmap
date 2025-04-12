//
//  IRCoachmarkProtocol.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 11.04.2025.
//

import UIKit

public protocol IRCoachmarkProtocol {
    var key: String { get }
    var ownerView: UIView { get }
    var title: String { get }
    var message: String { get }
    var snapshotMargin: UIEdgeInsets { get }
    var direction: IRCoachmarkDirection { get }
}

public extension IRCoachmarkProtocol {
    var didShow: Bool {
        UserDefaults.standard.bool(forKey: "\(IRCoachmarkManager.Constants.baseKey)\(key)")
    }
    
    func setShown() {
        UserDefaults.standard.set(true, forKey: "\(IRCoachmarkManager.Constants.baseKey)\(key)")
    }
}

public extension IRCoachmarkProtocol {
    func addSnapshot(to parentView: UIView) -> UIView? {
        parentView.addSnapshot(of: ownerView, with: snapshotMargin)
    }
}

final class IRSnapshotView: UIImageView {
    
}

public extension UIView {
    var snapshot: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { [weak self] _ in
            guard let self else { return }
            
            self.drawHierarchy(in: bounds, afterScreenUpdates: false)
        }
        
        return image
    }
    
    func addSnapshot(of view: UIView, with margin: UIEdgeInsets?) -> UIView? {
        guard let snapshot = view.snapshot,
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
        imageView.frame = .init(origin: updatedPoint, size: updatedSize)
        imageView.contentMode = .center
        imageView.backgroundColor = .gray.withAlphaComponent(0.3)
        imageView.layer.cornerRadius = 4
        
        addSubview(imageView)
        imageView.fadeIn()
        
        return imageView
    }
    
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

final class IRDarkView: UIView {
    
}

public extension UIView {
    
    func addDarkView(completion: (() -> Void)? = nil) {
        removeDarkView()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let darkView = IRDarkView(frame: .init(
                x: .zero,
                y: .zero,
                width: self.frame.size.width,
                height: self.frame.size.height
            ))
            
            darkView.backgroundColor = .black.withAlphaComponent(0.4)
            
            self.fit(subView: darkView)
            
            darkView.fadeIn {
                completion?()
            }
        }
    }
    
    func removeDarkView() {
        DispatchQueue.main.async { [weak self] in
            self?.subviews
                .lazy
                .filter { $0 is IRDarkView }
                .forEach { darkView in
                    darkView.fadeOut {
                        darkView.removeFromSuperview()
                    }
                }
        }
    }
}

public enum IRCoachmarkDirection {
    case top
    case bottom
}

public struct IRCoachmarkPageData {
    let title: String
    let description: String
    let numberOfPages: Int
    let pageIndex: Int
    let triangleViewMidX: CGFloat
    let direction: IRCoachmarkDirection
    let actionButtonTitle: String
    
    public init(
        title: String,
        description: String,
        numberOfPages: Int = 1,
        pageIndex: Int,
        triangleViewMidX: CGFloat,
        direction: IRCoachmarkDirection,
        actionButtonTitle: String) {
            self.title = title
            self.description = description
            self.numberOfPages = numberOfPages
            self.pageIndex = pageIndex
            self.triangleViewMidX = triangleViewMidX
            self.direction = direction
            self.actionButtonTitle = actionButtonTitle
        }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension UIApplication {
    
    var currentKeyWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    func topMostViewController() -> UIViewController? {
        currentKeyWindow?.rootViewController?.topMostViewController()
    }
}


extension UIViewController {
    func topMostViewController() -> UIViewController? {
        if let presentedViewController {
            return presentedViewController.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}
