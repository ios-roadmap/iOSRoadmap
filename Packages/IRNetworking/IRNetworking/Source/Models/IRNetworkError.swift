//
//  IRNetworkError.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

public enum IRNetworkError: Error {
    case invalidURL
    case encodingError(Error)
    case decodingError(Error)
    case httpError(statusCode: Int, message: String?)
    case noInternet
    case timeout
    case unknown(Error)
    case mockDataNotFound(String)
}
