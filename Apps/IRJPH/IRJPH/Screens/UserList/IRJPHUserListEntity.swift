//
//  IRJPHUser.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

import IRNetworking

enum IRJPHUserListEntity {
    struct Company: Codable {
        let name: String?
        let catchPhrase: String?
        let bs: String?
    }
    
    struct Geo: Codable {
        let lat: String?
        let lng: String?
    }

    struct Address: Codable {
        let street: String?
        let suite: String?
        let city: String?
        let zipcode: String?
        let geo: Geo?
    }

    struct User: Codable {
        let id: Int?
        let name: String?
        let username: String?
        let email: String?
        let phone: String?
        let website: String?
        let address: Address?
        let company: Company?
    }
    
    struct UsersRequest: IRAPIRequest {
        public typealias Response = [User]
        
        public var environment: IREnvironment { .jsonPlaceholder }
        public var path: String { IREndpoints.JsonPlaceHolder.users.path }
        public var method: HTTPMethod { .get }
        public var requiresAuth: Bool { false }
    }
}
