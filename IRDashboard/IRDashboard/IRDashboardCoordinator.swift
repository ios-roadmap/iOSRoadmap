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
        navigationController?.pushViewController(viewController, with: .zoom)
    }
}
