//
//  UserListRouter.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 5.03.2025.
//

import UIKit

class UserListRouter {
    weak var viewController: UIViewController?
    
    static func createModule() -> UserListViewController {
        let view = UserListViewController()
        let interactor = UserListInteractor()
        let presenter = UserListPresenter()
        let router = UserListRouter()
        
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = view
        router.viewController = view
        
        return view
    }
}
