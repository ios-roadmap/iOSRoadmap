//
//  IREndpointProtocol.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import Foundation

public protocol IREndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: IRHTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
}

public extension IREndpointProtocol {
    var headers: [String: String]? { nil }
    var body: Data? { nil }
    var queryItems: [URLQueryItem]? { nil }
    
    func asURLRequest() throws -> URLRequest? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}
