//
//  IRAPIRequest.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

@MainActor
public protocol IRAPIRequest {
    associatedtype Response: Decodable
    
    var environment: IREnvironment { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: Encodable? { get }
    var requiresAuth: Bool { get }
    
    /// Provide a filename (without extension) for the mock JSON.
    var mockFileName: String? { get }
}

public extension IRAPIRequest {
    var queryItems: [String: String]? { nil }
    var body: Encodable? { nil }
    var headers: [String: String]? { nil }
    var requiresAuth: Bool { false }
    
    var mockFileName: String? { nil }
}

public struct GenericAPIRequest<Response: Decodable>: IRAPIRequest, Sendable {
    public typealias Response = Response

    public let environment: IREnvironment
    public let path: String
    public let method: HTTPMethod
    public let queryItems: [String: String]?
    public let headers: [String: String]?
    public let body: Encodable?
    public let requiresAuth: Bool
    public let mockFileName: String?

    public init(environment: IREnvironment,
                path: String,
                method: HTTPMethod = .get,
                queryItems: [String: String]? = nil,
                headers: [String: String]? = nil,
                body: Encodable? = nil,
                requiresAuth: Bool = false,
                mockFileName: String? = nil) {
        self.environment = environment
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.requiresAuth = requiresAuth
        self.mockFileName = mockFileName
    }
}
