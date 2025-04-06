//
//  IRJPHUserListPresenter.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

final class IRJPHUserListPresenter: IRJPHUserListPresenterProtocol, IRJPHUserListInteractorOutput {
  
    weak var view: IRJPHUserListViewController?
    var interactor: IRJPHUserListInteractorProtocol?
    var router: IRJPHUserListRouterProtocol?
    
    var response: [IRJPHUserListEntity.User] = .init()
    
    func viewDidLoad() {
        view?.showLoading(true)
        Task {
            await interactor?.fetchUsers()
        }
    }
    
    func usersFetched(_ response: [IRJPHUserListEntity.User]) {
        view?.showLoading(false)
        self.response = response
        view?.showUsers(response)
    }
    
    func usersFetchFailed(_ error: Error) {
        view?.showLoading(false)
        print(error.localizedDescription)
        view?.showError("Failed to fetch users. Please try again.")
    }
    
    func didSelectUser(at index: Int) {
        guard index < response.count else { return }
        router?.navigateToUserDetail(user: response[index])
    }
}
