//
//  IRAPIErrorResponse.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

struct IRAPIErrorResponse: Decodable {
    let error: String?
    let message: String?
}
