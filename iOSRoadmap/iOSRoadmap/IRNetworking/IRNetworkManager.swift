//
//  IRService.swift
//  iOSRoadmap
//
//  Created by Ömer Faruk Öztürk on 13.02.2025.
//

import Foundation

protocol IRNetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: IRNetworkSession {}

final class IRNetworkManager {
    private let session: IRNetworkSession
    
    init(session: IRNetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: IREndpoint, responseType: T.Type) async -> Result<T, IRError> {
        do {
            guard let request = try endpoint.asURLRequest() else {
                return .failure(.invalidURL)
            }
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(.invalidResponse((response as? HTTPURLResponse)?.statusCode ?? -1))
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.decodingFailed(error))
            }
            
        } catch {
            return .failure(.requestFailed(error))
        }
    }
}

final class MockNetworkSession: IRNetworkSession {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError { throw error }
        return (mockData ?? Data(), mockResponse ?? HTTPURLResponse())
    }
}
