//
//  JPHUserListPresenter.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 21.04.2025.
//

import IRNetworking

final class JPHUserListPresenter: JPHUserListPresenterLogic {
    
    weak var view: JPHUserListViewControllerLogic?
    
    func presentUserList(_ result: Result<[JPHUserListEntity.User], Error>) {
        switch result {
        case .success(let users):
            view?.displayUserList(usersNames: users)
        case .failure(let error):
            view?.display(error: error.localizedDescription)
        }
    }
}
