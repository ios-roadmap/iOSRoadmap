//
//  IRDashboardFactory.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import UIKit
import IRDashboardInterface

public class IRDashboardFactory: IRDashboardFactoryProtocol {
    
    public init() { }

    public func create() -> any IRDashboardInterface {
        return IRDashboardCoordinator()
    }
}
