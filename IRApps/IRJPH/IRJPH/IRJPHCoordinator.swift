//
//  IRJPHCoordinator.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 16.03.2025.
//

import UIKit
import IRCore
import IRJPHInterface

@MainActor
public protocol IRJPHNavigationLogic {
    func logOut()
}

final class IRJPHCoordinator: IRBaseCoordinator, IRJPHInterface {

    override func start() -> UIViewController {
        let vc = IRJPHViewController()
        vc.navigator = self
        return vc
    }
}

extension IRJPHCoordinator: IRJPHNavigationLogic {
    func logOut() {
        navigationController?.popViewController(animated: true)
    }
}
