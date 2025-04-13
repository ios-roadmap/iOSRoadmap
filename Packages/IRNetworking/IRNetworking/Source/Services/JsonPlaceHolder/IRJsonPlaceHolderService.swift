//
//  IRJsonPlaceHolderService.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import Foundation

public typealias IRJPHUser = IRJsonPlaceHolderModels.User

public enum IRJsonPlaceHolderModels {
    
    public struct Company: Codable {
        public let name: String?
        public let catchPhrase: String?
        public let bs: String?
    }
    
    public struct Geo: Codable {
        public let lat: String?
        public let lng: String?
    }

    public struct Address: Codable {
        public let street: String?
        public let suite: String?
        public let city: String?
        public let zipcode: String?
        public let geo: Geo?
    }

    public struct User: Codable {
        public let id: Int?
        public let name: String?
        public let username: String?
        public let email: String?
        public let phone: String?
        public let website: String?
        public let address: Address?
        public let company: Company?
    }
}

@MainActor
public protocol IRJsonPlaceHolderServiceProtocol {
    func fetchUsers() async throws -> [IRJPHUser]
}

public final class IRJsonPlaceHolderService: IRBaseService, IRJsonPlaceHolderServiceProtocol {
    public func fetchUsers() async throws -> [IRJPHUser] {
        let request = GenericAPIRequest<[IRJPHUser]>(
            environment: .jsonPlaceholder,
            path: IREndpoints.JsonPlaceHolder.users.path,
            method: .get,
            requiresAuth: false
        )
        return try await execute(request)
    }
}
