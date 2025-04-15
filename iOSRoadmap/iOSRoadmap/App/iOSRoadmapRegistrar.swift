//
//  iOSRoadmapRegistrar.swift
//  iOSRoadmap
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import IRNetworking
import IRCore

import IRDashboard
import IRDashboardInterface
import IRJPH
import IRJPHInterface

@MainActor
enum IRDashboardDemoRegistrar {
    static func registerDepencies() {
        IRDependencyContainer.shared.register(IRJsonPlaceHolderServiceProtocol.self, scope: .service, factory: {
            IRJsonPlaceHolderService()
        })
        
        IRDependencyContainer.shared.register(IRDashboardInterface.self, scope: .module) { IRDashboardFactory().create() }
        IRDependencyContainer.shared.register(IRJPHInterface.self, scope: .module) { IRJPHFactory().create() }
    }
}
