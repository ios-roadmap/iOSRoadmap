//
//  IRJPHDemoLibraries.swift
//  IRJPHDemo
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import IRNetworking
import IRCore

@MainActor
public class IRJPHDemoLibraries {
    
    public static func registerDependencies() {
        IRDependencyContainer.shared.register(IRJsonPlaceHolderServiceProtocol.self, scope: .service) { IRJsonPlaceHolderService() }
    }
}
