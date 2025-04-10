//
//  IRJPHUserListInteractor.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import IRNetworking
import IRCore

final class IRJPHUserListInteractor: IRJPHUserListInteractorProtocol {
    weak var output: IRJPHUserListInteractorOutput?
    
    @IRService var userService: IRJsonPlaceHolderServiceProtocol

    func fetchUsers() async {
        do {
            let users = try await userService.fetchUsers()
            output?.usersFetched(users)
        } catch {
            output?.usersFetchFailed(error)
        }
    }

}
