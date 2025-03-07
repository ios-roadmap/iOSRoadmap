//
//  UINavigationController+Extension.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 23.02.2025.
//

import UIKit
import IRCommon

public extension UINavigationController {
    
    private func performTransition(_ action: () -> [UIViewController]?, completion: IRVoidHandler?) {
        let poppedViewControllers = action()
        
        guard let transitionCoordinator = transitionCoordinator, poppedViewControllers != nil else {
            completion?()
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: nil) { _ in
            completion?()
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: IRVoidHandler? = nil) {
        pushViewController(viewController, animated: animated)
        performTransition({ nil }, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: IRVoidHandler? = nil) {
        performTransition({ popToRootViewController(animated: animated) }, completion: completion)
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: IRVoidHandler? = nil) {
        performTransition({ popToViewController(viewController, animated: animated) }, completion: completion)
    }
    
    func dismissAndPopToRootViewController(animated: Bool, completion: IRVoidHandler? = nil) {
        dismiss(animated: animated) { [weak self] in
            self?.popToRootViewController(animated: animated, completion: completion)
        }
    }
    
    func dismissAndPopToViewController(_ viewController: UIViewController, animated: Bool, completion: IRVoidHandler? = nil) {
        dismiss(animated: animated) { [weak self] in
            self?.popToViewController(viewController, animated: animated, completion: completion)
        }
    }
}
