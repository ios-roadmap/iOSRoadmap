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
