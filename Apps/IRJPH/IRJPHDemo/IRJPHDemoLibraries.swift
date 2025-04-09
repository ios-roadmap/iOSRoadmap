//
//  IRJPHDemoLibraries.swift
//  IRJPHDemo
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import IRNetworking

@MainActor
public class IRJPHDemoLibraries {
    
    public static func registerDependencies() {
        IRNetworkServiceDependencies.register()
    }
}
