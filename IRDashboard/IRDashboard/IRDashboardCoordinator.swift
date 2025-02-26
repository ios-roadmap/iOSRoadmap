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
        let view = IRDashboardView()
        let presenter = IRDashboardPresenter()
        let interactor = IRDashboardInteractor()
        let router = IRDashboardRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}

extension IRDashboardCoordinator: IRDashboardNavigationLogic {
    
}
