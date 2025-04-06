//
//  IRMockNetworkService.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import Foundation

public final class MockNetworkService: IRNetworkServiceProtocol {
    
    var nextData: Data?
    var nextError: Error?
    private var responseMap: [String: Data] = [:]
    private var errorMap: [String: Error] = [:]

    func registerMockResponse(path: String, data: Data) {
        responseMap[path] = data
    }

    func registerMockError(path: String, error: Error) {
        errorMap[path] = error
    }

    func registerMockResponse(fromFile fileName: String, forPath path: String, bundle: Bundle = .main) {
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            responseMap[path] = try? Data(contentsOf: url)
        }
    }

    public func performRequest<T: IRAPIRequest>(_ request: T) async throws -> T.Response {
        if let error = errorMap[request.path] ?? nextError {
            throw error
        }
        
        if let data = responseMap[request.path] ?? nextData {
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.Response.self, from: data)
                return result
            } catch {
                throw IRNetworkError.decodingError(error)
            }
        }

        throw IRNetworkError.httpError(statusCode: 0, message: "No mock response for \(request.path)")
    }
}
