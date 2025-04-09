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
    
    public init(environment: IREnvironment,
         session: URLSession = .shared,
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
    
    func setAuthToken(_ token: String?) {
        self.authToken = token
    }
    
    public func performRequest<T: IRAPIRequest>(_ request: T) async throws -> T.Response {
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
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = timeout
        
        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                throw IRNetworkError.encodingError(error)
            }
        }
        
        var allHeaders: [String: String] = request.headers ?? [:]
        if request.requiresAuth, let token = authToken {
            if allHeaders["Authorization"] == nil {
                allHeaders["Authorization"] = "Bearer \(token)"
            }
        }

        for (header, value) in allHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }
        
#if DEBUG
        print("[Network] → \(request.method.rawValue) \(url.absoluteString)")
        if let headers = urlRequest.allHTTPHeaderFields {
            print("[Network] Headers: \(headers)")
        }
        if let bodyData = urlRequest.httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            print("[Network] Body: \(bodyString)")
        }
#endif
        
        var lastError: Error?
        for attempt in 1...maxRetries {
            do {
                let (data, response) = try await session.data(for: urlRequest)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw IRNetworkError.invalidURL
                }
                let statusCode = httpResponse.statusCode
                
#if DEBUG
                print("[Network] ← Response status: \(statusCode)")
#endif
                
                if !(200...299).contains(statusCode) {
                    let errorMessage = data.isEmpty ? nil : parseAPIErrorMessage(from: data)
#if DEBUG
                    if let msg = errorMessage {
                        print("[Network] API Error \(statusCode): \(msg)")
                    } else {
                        print("[Network] HTTP Error \(statusCode)")
                    }
#endif
                    if (500...599).contains(statusCode), attempt < maxRetries {
                        let delaySeconds = retryDelay * pow(2.0, Double(attempt - 1))
                        try await Task.sleep(nanoseconds: UInt64(delaySeconds * 1_000_000_000))
                        continue
                    } else {
                        throw IRNetworkError.httpError(statusCode: statusCode, message: errorMessage)
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.Response.self, from: data)
#if DEBUG
                    print("[Network] √ Response decoded successfully.")
#endif
                    return result
                } catch {
                    throw IRNetworkError.decodingError(error)
                }
            } catch {
                lastError = error
                if attempt < maxRetries {
                    if let urlError = error as? URLError, isRetriableError(urlError) {
#if DEBUG
                        print("[Network] Retryable network error: \(urlError.code.rawValue). Retrying (attempt \(attempt+1))...")
#endif
                        let delaySeconds = retryDelay * pow(2.0, Double(attempt - 1))
                        try await Task.sleep(nanoseconds: UInt64(delaySeconds * 1_000_000_000))
                        continue
                    }
                }
                if let netErr = error as? IRNetworkError {
                    throw netErr
                } else if let urlErr = error as? URLError {
                    switch urlErr.code {
                    case .notConnectedToInternet:
                        throw IRNetworkError.noInternet
                    case .timedOut:
                        throw IRNetworkError.timeout
                    default:
                        throw IRNetworkError.unknown(urlErr)
                    }
                } else {
                    throw IRNetworkError.unknown(error)
                }
            }
        }
        throw lastError ?? IRNetworkError.unknown(NSError(domain: "NetworkService", code: -1, userInfo: nil))
    }
    
    func isRetriableError(_ error: Error) -> Bool {
        if let urlError = error as? URLError {
            return urlError.code == .timedOut ||
            urlError.code == .networkConnectionLost ||
            urlError.code == .cannotFindHost ||
            urlError.code == .cannotConnectToHost ||
            urlError.code == .dnsLookupFailed ||
            urlError.code == .notConnectedToInternet
        }
        return false
    }
    
    func parseAPIErrorMessage(from data: Data) -> String? {
        if let errorResponse = try? JSONDecoder().decode(IRAPIErrorResponse.self, from: data) {
            return errorResponse.message ?? errorResponse.error
        }
        return nil
    }
}
