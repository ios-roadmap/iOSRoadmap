//
//  IRDashboardCoordinator.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import UIKit
import IRCore
import IRDashboardInterface
import IRJPH

@MainActor
protocol IRDashboardNavigationLogic {
    func navigationToJPHApp()
}

typealias NavigationLogic = IRDashboardNavigationLogic

public class IRDashboardCoordinator: IRBaseCoordinator, IRDashboardInterface {
    
//    private let navigationDelegate = CustomNavigationControllerDelegate() // Delegate burada tutuluyor
    
    public override init() {
        super.init()
    }
    
    public override func start() -> UIViewController {
        let viewController = IRDashboardController()
        viewController.navigator = self
        return viewController
    }
}

extension IRDashboardCoordinator: IRDashboardNavigationLogic {
    func navigationToJPHApp() {
        let viewController = IRJPHViewController()
//        navigationController?.delegate = navigationDelegate  Delegate burada set ediliyor
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.5 // Animasyon süresi
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let toView = transitionContext.view(forKey: .to) else { return }
//        
//        let containerView = transitionContext.containerView
//        toView.alpha = 0.0
//        containerView.addSubview(toView)
//        
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            toView.alpha = 1.0
//        }) { finished in
//            transitionContext.completeTransition(finished)
//        }
//    }
//}
//
//class CustomNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
//    func navigationController(
//        _ navigationController: UINavigationController,
//        animationControllerFor operation: UINavigationController.Operation,
//        from fromVC: UIViewController,
//        to toVC: UIViewController
//    ) -> UIViewControllerAnimatedTransitioning? {
//        return CustomPushAnimator()
//    }
//}
