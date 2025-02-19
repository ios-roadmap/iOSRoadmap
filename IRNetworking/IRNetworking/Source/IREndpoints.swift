//
//  IREndpoints.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import Foundation

public enum IREndpoints {
    
    public enum RickAndMorty {
        case character
        
        static var baseURL: String = "https://rickandmortyapi.com/api"
        
        public var endpoint: IREndpoint {
            switch self {
            case .character:
                return IREndpoint(baseURL: RickAndMorty.baseURL,
                                  path: "/character",
                                  method: .get)
            }
        }
    }
}
