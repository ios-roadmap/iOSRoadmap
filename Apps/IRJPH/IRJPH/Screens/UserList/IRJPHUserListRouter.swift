//
//  IRJPHUserListRouter.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit
import IRNetworking

final class IRJPHUserListRouter: IRJPHUserListRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func build() -> UIViewController {
        let service = IRNetworkService(environment: .jsonPlaceholder)
        let interactor = IRJPHUserListInteractor(service: service)
        let presenter = IRJPHUserListPresenter()
        let router = IRJPHUserListRouter()
        let view = IRJPHUserListViewController()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToUserDetail(user: IRJPHUserListEntity.User) {
        guard let sourceVC = viewController, let navigation = sourceVC.navigationController else {
            return
        }
        
        let detailVC = UIViewController()
        navigation.pushViewController(detailVC, animated: true)
    }
}
