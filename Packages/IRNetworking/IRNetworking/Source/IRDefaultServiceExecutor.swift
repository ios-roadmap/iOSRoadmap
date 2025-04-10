//
//  IRBaseService.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 10.04.2025.
//

@MainActor
open class IRBaseService {
    private let networkService: IRNetworkServiceProtocol

    public init(networkService: IRNetworkServiceProtocol = IRNetworkService()) {
        self.networkService = networkService
    }

    public func execute<T: IRAPIRequest>(_ request: T) async throws -> T.Response {
        try await networkService.performRequest(request)
    }
}
