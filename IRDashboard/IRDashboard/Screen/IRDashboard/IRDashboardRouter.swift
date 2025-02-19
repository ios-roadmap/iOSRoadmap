//
//  IRDashboardRouter.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import UIKit

public protocol IRDashboardRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

public class IRDashboardRouter: @preconcurrency IRDashboardRouterProtocol {
    
    @MainActor public static func createModule() -> UIViewController {
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

