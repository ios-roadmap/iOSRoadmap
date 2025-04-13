//
//  IREnvironment.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

import Foundation

public enum IREnvironment {
    case jsonPlaceholder
    
    var baseURL: URL {
        switch self {
        case .jsonPlaceholder:
            return URL(string: "https://jsonplaceholder.typicode.com")!
        }
    }
}

public struct AnyEncodable: Encodable {
    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    public func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
