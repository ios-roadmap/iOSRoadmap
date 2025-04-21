//
//  JPHUserListRouter.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 21.04.2025.
//

import UIKit

@MainActor
public enum JPHUserListRouter {
    
    static func build() -> JPHUserListViewController {
        let presenter = JPHUserListPresenter()
        let interactor = JPHUserListInteractor(presenter: presenter)
        let view = JPHUserListViewController(interactor: interactor)
        presenter.view = view
        return view
    }
    
    static func navigateToDetail(from vc: UIViewController, user: JPHUserListEntity.User) {
        let detailVC = IRJPHUserDetailViewController(userName: user.name ?? "")
        vc.navigationController?.pushViewController(detailVC, animated: true)
    }
}
