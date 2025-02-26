//
//  IRDashboardInteractor.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import Foundation

public class IRDashboardInteractor: IRDashboardInteractorProtocol {
    
    public weak var presenter: IRDashboardInteractorOutputProtocol?

    public init() {}

    public func fetchDashboardData() {
        let data = [
            IRDashboardItem(title: "Revenue", value: "$5000", icon: "💰"),
            IRDashboardItem(title: "Users", value: "1200", icon: "👥"),
            IRDashboardItem(title: "Orders", value: "320", icon: "📦")
        ]
        presenter?.dashboardDataFetched(data)
    }
}
