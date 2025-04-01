//
//  UINavigationController+Extension.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 23.02.2025.
//

import UIKit

public extension UINavigationController {
    
    private func performTransition(_ action: () -> [UIViewController]?, completion: (() -> Void)?) {
        let poppedViewControllers = action()
        
        guard let transitionCoordinator = transitionCoordinator, poppedViewControllers != nil else {
            completion?()
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: nil) { _ in
            completion?()
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        pushViewController(viewController, animated: animated)
        performTransition({ nil }, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: (() -> Void)? = nil) {
        performTransition({ popToRootViewController(animated: animated) }, completion: completion)
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        performTransition({ popToViewController(viewController, animated: animated) }, completion: completion)
    }
    
    func dismissAndPopToRootViewController(animated: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: animated) { [weak self] in
            self?.popToRootViewController(animated: animated, completion: completion)
        }
    }
    
    func dismissAndPopToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: animated) { [weak self] in
            self?.popToViewController(viewController, animated: animated, completion: completion)
        }
    }
}
