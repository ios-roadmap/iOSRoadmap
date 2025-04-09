//
//  RegisterDepencies.swift
//  IRDashboardDemo
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import IRCore
import IRJPH
import IRJPHInterface

@MainActor
enum IRDashboardDemoRegistrar {
    static func registerDepencies() {
        IRDependencyContainer.shared.register(IRJPHInterface.self) {
            IRJPHFactory().create()
        }

    }
}
