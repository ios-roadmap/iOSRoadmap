//
//  File.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import IRCore

@MainActor
public enum IRNetworkServiceDependencies {
    
    public static func register() {
        IRDependencyContainer.shared.register(IRJPHUserServiceProtocol.self, scope: .service) {
            let networkService = IRNetworkService(environment: .jsonPlaceholder)
            return IRJsonPlaceHolderService(network: networkService)
        }
    }
}
