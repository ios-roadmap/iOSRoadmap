//
//  IRDashboardFactory.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import Foundation
import IRDashboardInterface

public class IRDashboardFactory: @preconcurrency IRDashboardFactoryProtocol {
    public init() {}
    
    @MainActor public func create() -> IRDashboardInterface {
        return IRDashboardCoordinator()
    }
}
