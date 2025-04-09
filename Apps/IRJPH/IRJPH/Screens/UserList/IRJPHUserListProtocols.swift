//
//  IRJPHUserListProtocols.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

import UIKit

// VIEW -> PRESENTER
@MainActor
protocol IRJPHUserListPresenterProtocol: AnyObject {
    var response: [IRJPHUserListEntity.User] { get }

    func viewDidLoad()
    func didSelectUser(at index: Int)
}

// PRESENTER -> VIEW
@MainActor
protocol IRJPHUserListViewProtocol: AnyObject {
    func showUsers(_ users: [IRJPHUserListEntity.User])
    func showError(_ message: String)
    func showLoading(_ isLoading: Bool)
}

// PRESENTER -> INTERACTOR
@MainActor
protocol IRJPHUserListInteractorProtocol: AnyObject {
    func fetchUsers()
}

// INTERACTOR -> PRESENTER (Interactor Output)
@MainActor
protocol IRJPHUserListInteractorOutput: AnyObject {
    func usersFetched(_ response: [IRJPHUserListEntity.User])
    func usersFetchFailed(_ error: Error)
}

// PRESENTER -> ROUTER
@MainActor
protocol IRJPHUserListRouterProtocol: AnyObject {
    func navigateToUserDetail(user: IRJPHUserListEntity.User)
}
