//
//  IREndpoint.swift
//  iOSRoadmap
//
//  Created by Ömer Faruk Öztürk on 13.02.2025.
//

import Foundation

protocol IREndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: IRHTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension IREndpointProtocol {
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

struct IREndpoint: IREndpointProtocol {
    let baseURL: String
    let path: String
    let method: IRHTTPMethod
    let headers: [String: String]?
    let body: Data?
    let queryItems: [URLQueryItem]?
    
    init(
        baseURL: String,
        path: String,
        method: IRHTTPMethod,
        headers: [String: String]? = nil,
        body: Data? = nil,
        queryItems: [URLQueryItem]? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.queryItems = queryItems
    }
}
