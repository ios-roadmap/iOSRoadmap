//
//  IREndpoints.swift
//  iOSRoadmap
//
//  Created by Ömer Faruk Öztürk on 13.02.2025.
//

import Foundation

enum IREndpoints {
    
    enum RickAndMorty {
        case character
        
        static var baseURL: String = "https://rickandmortyapi.com/api"
        
        var endpoint: IREndpoint {
            switch self {
            case .character:
                return IREndpoint(baseURL: RickAndMorty.baseURL,
                                  path: "/character",
                                  method: .get)
            }
        }
    }
}
