//
//  IRNetworkService.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

import Foundation

@MainActor
public protocol IRNetworkServiceProtocol {
    func performRequest<T: IRAPIRequest>(_ request: T) async throws -> T.Response
}

public final class IRNetworkService: IRNetworkServiceProtocol {
    
    private let session: URLSession
    private var authToken: String?
    private let timeout: TimeInterval
    private let maxRetries: Int
    private let retryDelay: TimeInterval
    
    public init(session: URLSession = .shared,
                authToken: String? = nil,
                timeout: TimeInterval = 10.0,
                maxRetries: Int = 3,
                retryDelay: TimeInterval = 1.0) {
        self.session = session
        self.authToken = authToken
        self.timeout = timeout
        self.maxRetries = maxRetries
        self.retryDelay = retryDelay
    }
    
    private func setAuthToken(_ token: String?) {
        self.authToken = token
    }
    
    public func performRequest<T: IRAPIRequest>(_ request: T) async throws -> T.Response {
        if request.mockFileName != nil {
            return try loadMockResponse(for: request)
        }
        
        let urlRequest = try buildURLRequest(for: request)
        logRequest(urlRequest, method: request.method.rawValue)
        return try await send(urlRequest, for: request)
    }
    
    // MARK: - Private Helpers
    
    private func loadMockResponse<T: IRAPIRequest>(for request: T) throws -> T.Response {
        guard let mockFileName = request.mockFileName,
              let url = Bundle.main.url(forResource: mockFileName, withExtension: "json") else {
            throw IRNetworkError.mockDataNotFound("Mock file \(request.mockFileName ?? "unknown").json not found in Bundle.module")
        }
        IRLogger.debug("[Network-Mock] Loading data from \(mockFileName).json")
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.Response.self, from: data)
    }
    
    private func buildURLRequest<T: IRAPIRequest>(for request: T) throws -> URLRequest {
        // Construct URL with query parameters
        guard var urlComponents = URLComponents(url: request.environment.baseURL.appendingPathComponent(request.path),
                                                resolvingAgainstBaseURL: false) else {
            throw IRNetworkError.invalidURL
        }
        if let queryItems = request.queryItems {
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            throw IRNetworkError.invalidURL
        }
        
        // Create URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = timeout
        
        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(AnyEncodable(body))
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                throw IRNetworkError.encodingError(error)
            }
        }
        
        // Merge headers
        var headers = request.headers ?? [:]
        if request.requiresAuth, let token = authToken, headers["Authorization"] == nil {
            headers["Authorization"] = "Bearer \(token)"
        }
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    private func send<T: IRAPIRequest>(_ urlRequest: URLRequest, for request: T) async throws -> T.Response {
        var lastError: Error?
        for attempt in 1...maxRetries {
            do {
                let (data, response) = try await session.data(for: urlRequest)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw IRNetworkError.invalidURL
                }
                IRLogger.debug("← Response status: \(httpResponse.statusCode)")
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let errorMessage = data.isEmpty ? nil : parseAPIErrorMessage(from: data)
                    IRLogger.debug("HTTP Error \(httpResponse.statusCode): \(errorMessage ?? "No message")")
                    if (500...599).contains(httpResponse.statusCode), attempt < maxRetries {
                        try await Task.sleep(nanoseconds: UInt64(calculateDelay(for: attempt) * 1_000_000_000))
                        continue
                    } else {
                        throw IRNetworkError.httpError(statusCode: httpResponse.statusCode, message: errorMessage)
                    }
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.Response.self, from: data)
                IRLogger.debug("√ Response decoded successfully.")
                return result
            } catch {
                lastError = error
                if attempt < maxRetries,
                   let urlError = error as? URLError,
                   isRetriableError(urlError) {
                    IRLogger.debug("Retryable error \(urlError.code.rawValue). Retrying (attempt \(attempt + 1))...")
                    try await Task.sleep(nanoseconds: UInt64(calculateDelay(for: attempt) * 1_000_000_000))
                    continue
                }
                throw mapError(error)
            }
        }
        throw lastError ?? IRNetworkError.unknown(NSError(domain: "IRNetworkService", code: -1, userInfo: nil))
    }
    
    private func logRequest(_ request: URLRequest, method: String) {
        IRLogger.debug("→ \(method) \(request.url?.absoluteString ?? "Unknown URL")")
        if let headers = request.allHTTPHeaderFields {
            IRLogger.debug("Headers: \(headers)")
        }
        if let bodyData = request.httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            IRLogger.debug("Body: \(bodyString)")
        }
    }
    
    private func calculateDelay(for attempt: Int) -> TimeInterval {
        return retryDelay * pow(2.0, Double(attempt - 1))
    }
    
    private func isRetriableError(_ error: URLError) -> Bool {
        switch error.code {
        case .timedOut,
             .networkConnectionLost,
             .cannotFindHost,
             .cannotConnectToHost,
             .dnsLookupFailed,
             .notConnectedToInternet:
            return true
        default:
            return false
        }
    }
    
    private func parseAPIErrorMessage(from data: Data) -> String? {
        if let errorResponse = try? JSONDecoder().decode(IRAPIErrorResponse.self, from: data) {
            return errorResponse.message ?? errorResponse.error
        }
        return nil
    }
    
    private func mapError(_ error: Error) -> IRNetworkError {
        if let netError = error as? IRNetworkError {
            return netError
        } else if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet: return .noInternet
            case .timedOut: return .timeout
            default: return .unknown(urlError)
            }
        }
        return .unknown(error)
    }
}

import Foundation

public final class IRLogger {
    public static func debug(_ message: String) {
        #if DEBUG
        print("[DEBUG] \(message)")
        #endif
    }
}
