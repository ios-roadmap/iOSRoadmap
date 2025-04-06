//
//  IRNetworkError.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

public enum IRNetworkError: Error {
    case invalidURL
    case noInternet
    case timeout
    case httpError(statusCode: Int, message: String?)
    case decodingError(Error)
    case encodingError(Error)
    case unknown(Error)
}
