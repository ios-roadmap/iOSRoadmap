//
//  IRAPIRequest.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

public protocol IRAPIRequest {
    associatedtype Response: Decodable

    var environment: IREnvironment { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String]? { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
    var requiresAuth: Bool { get }
}

public extension IRAPIRequest {
    var queryItems: [String: String]? { nil }
    var body: Encodable? { nil }
    var headers: [String: String]? { nil }
    var requiresAuth: Bool { false }
}
