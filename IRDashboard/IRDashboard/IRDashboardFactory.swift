//
//  IRDashboardFactory.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import Foundation
import IRDashboardInterface

@MainActor
public class IRDashboardFactory: @preconcurrency IRDashboardFactoryProtocol {
    public init() {}
    
    public func create() -> IRDashboardInterface {
        return IRDashboardCoordinator()
    }
}
