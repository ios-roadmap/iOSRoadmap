//
//  JPHUserListEntity.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 21.04.2025.
//

import IRNetworking

public enum JPHUserListEntity {
    
    struct Build {
        var navigator: NavigationLogic
        var data: JPHUserListData = .init()
    }
    
    struct JPHUserListData {
        
    }
    
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

//TODO: Burası Service Katmanına taşınmalı ya da modülün service'i ayrı olmalı. Burası düşünülecek.

@MainActor
public protocol JsonPlaceHolderServiceProtocol {
    func fetchUsers() async throws -> [JPHUserListEntity.User]
}

public final class JsonPlaceHolderService: IRBaseService, JsonPlaceHolderServiceProtocol {
    public func fetchUsers() async throws -> [JPHUserListEntity.User] {
        let request = GenericAPIRequest<[JPHUserListEntity.User]>(
            environment: .jsonPlaceholder,
            path: IREndpoints.JsonPlaceHolder.users.path,
            method: .get,
            requiresAuth: false
        )
        return try await execute(request)
    }
}
