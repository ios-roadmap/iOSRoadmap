//
//  IRMockNetworkService.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import Foundation

public final class MockNetworkService: IRNetworkServiceProtocol {
    private var mockResponses: [String: Data] = [:]

    public init() {}

    public func registerMock(fromFileNamed fileName: String,
                             forPath path: String,
                             bundle: Bundle) {
        guard let url = bundle.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            assertionFailure("Mock JSON file \(fileName).json not found in bundle.")
            return
        }
        mockResponses[path] = data
    }

    public func performRequest<T: IRAPIRequest>(_ request: T) async throws -> T.Response {
        guard let data = mockResponses[request.path] else {
            throw IRNetworkError.httpError(statusCode: 0, message: "No mock data registered for path: \(request.path)")
//            throw IRNetworkError.invalidMockData("No mock data registered for path: \(request.path)")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.Response.self, from: data)
    }
}
