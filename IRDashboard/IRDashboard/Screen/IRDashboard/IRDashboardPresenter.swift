//
//  IRDashboardPresenter.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import Foundation

public protocol IRDashboardPresenterProtocol: AnyObject {
    func viewDidLoad()
}

public class IRDashboardPresenter: IRDashboardPresenterProtocol {
    
    public weak var view: IRDashboardViewProtocol?
    public var interactor: IRDashboardInteractorProtocol?
    public var router: IRDashboardRouterProtocol?

    public init() {}

    public func viewDidLoad() {
        interactor?.fetchDashboardData()
    }
}

extension IRDashboardPresenter: IRDashboardInteractorOutputProtocol {
    public func dashboardDataFetched(_ data: [IRDashboardItem]) {
        view?.showDashboardData(data)
    }
}

