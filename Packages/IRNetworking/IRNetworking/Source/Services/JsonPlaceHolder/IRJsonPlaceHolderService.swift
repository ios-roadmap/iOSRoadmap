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
    
    public struct UsersRequest: IRAPIRequest {
        public typealias Response = [User]
        
        public var environment: IREnvironment { .jsonPlaceholder }
        public var path: String { IREndpoints.JsonPlaceHolder.users.path }
        public var method: HTTPMethod { .get }
        public var requiresAuth: Bool { false }
    }
}

@MainActor
public protocol IRJPHUserServiceProtocol {
    func fetchUsers() async throws -> [IRJsonPlaceHolderModels.User]
}

@MainActor
public final class IRJsonPlaceHolderService: IRJPHUserServiceProtocol {
    
    private let network: IRNetworkServiceProtocol

    public init(network: IRNetworkServiceProtocol) {
        self.network = network
    }

    public func fetchUsers() async throws -> [IRJsonPlaceHolderModels.User] {
        let request = IRJsonPlaceHolderModels.UsersRequest()
        return try await network.performRequest(request)
    }
}
