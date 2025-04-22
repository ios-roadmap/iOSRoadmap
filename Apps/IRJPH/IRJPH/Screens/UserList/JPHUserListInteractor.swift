//
//  JPHUserListInteractor.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 21.04.2025.
//

import Foundation
import IRCore
import IRNetworking

public final class JPHUserListInteractor: JPHUserListInteractorLogic {
    
    @IRService private var userService: JsonPlaceHolderServiceProtocol
    private let presenter: JPHUserListPresenterLogic
    
    init(presenter: JPHUserListPresenterLogic) {
        self.presenter = presenter
    }
    
    public func fetchUserList() {
        Task { [presenter] in
            do {
                let users = try await userService.fetchUsers()
                presenter.presentUserList(.success(users))
            } catch {
                presenter.presentUserList(.failure(error))
            }
        }
    }
}
