//
//  IRJPHUserListInteractor.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import IRNetworking

final class IRJPHUserListInteractor: IRJPHUserListInteractorProtocol {
    weak var output: IRJPHUserListInteractorOutput?
    private let service: IRNetworkServiceProtocol

    init(service: IRNetworkServiceProtocol) {
        self.service = service
    }

    func fetchUsers() async {
        let request = IRJPHUserListEntity.UsersRequest()
        do {
            let response = try await service.performRequest(request)
            output?.usersFetched(response)
        } catch {
            output?.usersFetchFailed(error)
        }
    }
}
