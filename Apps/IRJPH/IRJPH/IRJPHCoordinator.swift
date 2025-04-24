//
//  IRJPHCoordinator.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 16.03.2025.
//

import IRCore
import IRJPHInterface
import UIKit

typealias NavigationLogic = JPHUserListRouterLogic

public class IRJPHCoordinator: IRCoordinator, IRJPHInterface {
    
    public init() {
        super.init()
    }
    
    public override func start() {
        let dashboardVC = JPHUserListBuild.build(with: .init(navigator: self))
        navigate(to: dashboardVC)
    }
}

extension IRJPHCoordinator: NavigationLogic {
    func navigateToDetail(from vc: UIViewController, user: JPHUserListEntity.User) {
        let detailVC = IRJPHUserDetailViewController(userName: user.name ?? "")
        vc.navigationController?.pushViewController(detailVC, animated: true)
    }
}
