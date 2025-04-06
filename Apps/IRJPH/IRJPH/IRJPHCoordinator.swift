//
//  IRJPHCoordinator.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 16.03.2025.
//

import UIKit
import IRCore
import IRJPHInterface

public class IRJPHCoordinator: IRCoordinator, IRJPHInterface {
    
    public override func start() {
        let dashboardVC = IRJPHUserListRouter.build()
        navigate(to: dashboardVC)
    }
}
