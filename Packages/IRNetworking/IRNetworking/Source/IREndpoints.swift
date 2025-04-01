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
        
      
        
        public var endpoint: IREndpoint {
            switch self {
            case .character:
                return IREndpoint(baseURL: "https://rickandmortyapi.com/api",
                                  path: "/character",
                                  method: .get)
            }
        }
    }
}
