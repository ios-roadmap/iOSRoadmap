//
//  IRJPHUserListProtocols.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

import UIKit
import IRNetworking

// VIEW -> PRESENTER
@MainActor
protocol IRJPHUserListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectUser(_ user: IRJPHUser)
}

// PRESENTER -> VIEW
@MainActor
protocol IRJPHUserListViewProtocol: AnyObject {
    func showUsers(_ users: [IRJPHUser])
    func showError(_ message: String)
    func setLoading(_ isLoading: Bool)
}

// PRESENTER -> INTERACTOR
@MainActor
protocol IRJPHUserListInteractorProtocol: AnyObject {
    func fetchUsers() async
}

// INTERACTOR -> PRESENTER (Interactor Output)
@MainActor
protocol IRJPHUserListInteractorOutput: AnyObject {
    func usersFetched(_ response: [IRJPHUser])
    func usersFetchFailed(_ error: Error)
}

// PRESENTER -> ROUTER
@MainActor
protocol IRJPHUserListRouterProtocol: AnyObject {
    func navigateToUserDetail(user: IRJPHUser)
}
