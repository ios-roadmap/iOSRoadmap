//
//  IRDashboardCoordinator.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import IRCore

import IRDashboardInterface
import IRJPHInterface

@MainActor
protocol IRDashboardNavigateAppsProtocol {
    func navigateToJPHApp()
}

typealias IRDashboardNavigationLogic = IRDashboardNavigateAppsProtocol

public class IRDashboardCoordinator: IRCoordinator, IRDashboardInterface {
    
    @IRLazyInjected private var jphCoordinator: IRJPHInterface
    
    public override func start() {
        let dashboardVC = IRDashboardController()
        dashboardVC.navigator = self
        navigate(to: dashboardVC, with: .push)
    }
}

extension IRDashboardCoordinator: IRDashboardNavigationLogic {
    func navigateToJPHApp() {
        childCoordinator = jphCoordinator as? IRCoordinator
        //İşte burada wrappedValue tetiklenir, container.resolve() çağrılır ve factory devreye girer.
        startChildCoordinator(jphCoordinator, with: .push, animated: true)
    }
}
