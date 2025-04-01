//
//  IRNavigationControllerDelegate.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 16.03.2025.
//

import UIKit

public enum IRNavigationAnimationType {
    case fade
    case slide
    case zoom
    case none
}

public extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, with animation: IRNavigationAnimationType = .fade) {
        guard animation != .none else {
            pushViewController(viewController, animated: false)
            return
        }
        
        let delegate = IRNavigationControllerDelegate(animationType: animation)
        self.delegate = delegate
        pushViewController(viewController, animated: true)
    }
}

public final class IRNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    private let animationType: IRNavigationAnimationType
    
    public init(animationType: IRNavigationAnimationType = .none) {
        self.animationType = animationType
    }
    
    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .push else { return nil }
        return IRNavigationPushAnimator(animationType: animationType)
    }
}

class IRNavigationPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationType: IRNavigationAnimationType
    
    init(animationType: IRNavigationAnimationType) {
        self.animationType = animationType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        let duration = transitionDuration(using: transitionContext)
        
        switch animationType {
        case .fade:
            toView.alpha = 0.0
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1.0
            }) { finished in
                transitionContext.completeTransition(finished)
            }

        case .slide:
            let screenWidth = containerView.frame.width
            toView.transform = CGAffineTransform(translationX: screenWidth, y: 0)
            UIView.animate(withDuration: duration, animations: {
                toView.transform = .identity
            }) { finished in
                transitionContext.completeTransition(finished)
            }

        case .zoom:
            toView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            toView.alpha = 0.0
            UIView.animate(withDuration: duration, animations: {
                toView.transform = .identity
                toView.alpha = 1.0
            }) { finished in
                transitionContext.completeTransition(finished)
            }

        case .none:
            transitionContext.completeTransition(true)
        }
    }
}
