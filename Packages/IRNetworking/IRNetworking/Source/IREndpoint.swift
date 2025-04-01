//
//  IREndpoint.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import Foundation

public struct IREndpoint: IREndpointProtocol {
    public let baseURL: String
    public let path: String
    public let method: IRHTTPMethod
    public let headers: [String: String]?
    public let body: Data?
    public let queryItems: [URLQueryItem]?
    
    public init(
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

public enum IRHTTPMethod: String {
    case get
    case post
}

public enum IRError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse(Int)
    case decodingFailed(Error)
}

public enum IREndpointHeader {
    case contentType(String)
    case accept(String)
    case authorization(String)
    case userAgent(String)
    case acceptEncoding(String)
    case cacheControl(String)
    case connection(String)
    case host(String)
    case contentLength(String)
    case xRequestID(String)
    case xForwardedFor(String)
    case referer(String)
    case origin(String)
    case acceptLanguage(String)

    public var key: String {
        switch self {
        case .contentType: return "Content-Type"
        case .accept: return "Accept"
        case .authorization: return "Authorization"
        case .userAgent: return "User-Agent"
        case .acceptEncoding: return "Accept-Encoding"
        case .cacheControl: return "Cache-Control"
        case .connection: return "Connection"
        case .host: return "Host"
        case .contentLength: return "Content-Length"
        case .xRequestID: return "X-Request-ID"
        case .xForwardedFor: return "X-Forwarded-For"
        case .referer: return "Referer"
        case .origin: return "Origin"
        case .acceptLanguage: return "Accept-Language"
        }
    }

    public var value: String {
        switch self {
        case .contentType(let value),
             .accept(let value),
             .authorization(let value),
             .userAgent(let value),
             .acceptEncoding(let value),
             .cacheControl(let value),
             .connection(let value),
             .host(let value),
             .contentLength(let value),
             .xRequestID(let value),
             .xForwardedFor(let value),
             .referer(let value),
             .origin(let value),
             .acceptLanguage(let value):
            return value
        }
    }
}
