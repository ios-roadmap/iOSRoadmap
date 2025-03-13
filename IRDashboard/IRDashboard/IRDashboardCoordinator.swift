//
//  IRDashboardCoordinator.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import UIKit
import IRDashboardInterface
import IRCore

protocol IRDashboardNavigationLogic {
    
}

public class IRDashboardCoordinator: IRBaseCoordinator, IRDashboardInterface {
    
    public override init() {
        super.init()
    }
    
    public override func start() -> UIViewController {
//        IRDashboardRouter.createModule()
        UIViewController()
    }
}

extension IRDashboardCoordinator: IRDashboardNavigationLogic {
    
}
