//
//  RegisterDepencies.swift
//  IRDashboardDemo
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import IRNetworking
import IRCore

import IRJPH
import IRJPHInterface

@MainActor
enum IRDashboardDemoRegistrar {
    static func registerDepencies() {
//        IRNetworkServiceDependencies.register()
        
        IRDependencyContainer.shared.register(IRJPHInterface.self, scope: .module) { IRJPHFactory().create() }
    }
}
