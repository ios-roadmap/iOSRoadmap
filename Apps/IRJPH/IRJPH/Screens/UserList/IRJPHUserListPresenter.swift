//
//  IRJPHUserListPresenter.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import IRNetworking

final class IRJPHUserListPresenter: IRJPHUserListPresenterProtocol, IRJPHUserListInteractorOutput {

    weak var view: IRJPHUserListViewController?
    var interactor: IRJPHUserListInteractorProtocol?
    var router: IRJPHUserListRouterProtocol?
    
    private var users: [IRJPHUser] = []

    func viewDidLoad() {
        view?.setLoading(true)
        Task {
            await interactor?.fetchUsers()
        }
    }

    func usersFetched(_ response: [IRJPHUser]) {
        users = response
        view?.setLoading(false)
        view?.showUsers(response)
    }

    func usersFetchFailed(_ error: Error) {
        view?.setLoading(false)
        view?.showError(error.localizedDescription)
    }

    func didSelectUser(_ user: IRJPHUser) {
        router?.navigateToUserDetail(user: user)
    }
}
