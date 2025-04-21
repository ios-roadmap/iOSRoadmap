//
//  IRJPHDemoLibraries.swift
//  IRJPHDemo
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import IRCore
import IRJPH

@MainActor
public class IRJPHDemoLibraries {
    
    public static func registerDependencies() {
        IRDependencyContainer.shared.register(JsonPlaceHolderServiceProtocol.self, scope: .service) { JsonPlaceHolderService() }
    }
}
