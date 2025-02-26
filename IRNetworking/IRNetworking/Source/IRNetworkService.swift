//
//  IRNetworkService.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import Foundation

public protocol IRNetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: IRNetworkSession {}

public final class IRNetworkService {
    private let session: IRNetworkSession
    
    public init(session: IRNetworkSession = URLSession.shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(_ endpoint: IREndpoint, responseType: T.Type) async -> Result<T, IRError> {
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
