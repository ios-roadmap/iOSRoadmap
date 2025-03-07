//
//  IRDashboardContacts.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 24.02.2025.
//

import UIKit

@MainActor
public protocol IRDashboardInteractorOutputProtocol: AnyObject {
    func dashboardDataFetched(_ data: [IRDashboardItem])
}

@MainActor
public protocol IRDashboardInteractorProtocol: AnyObject {
    func fetchDashboardData()
}

@MainActor
public protocol IRDashboardPresenterProtocol: AnyObject {
    func viewDidLoad()
}

@MainActor
public protocol IRDashboardRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

@MainActor
public protocol IRDashboardViewProtocol: AnyObject {
    func showDashboardData(_ data: [IRDashboardItem])
}
