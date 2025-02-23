//
//  IRBaseCoordinator.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 23.02.2025.
//

import UIKit

@MainActor
open class IRBaseCoordinator: IRCoordinatorProtocol, @unchecked Sendable {
    public weak var navigationController: UINavigationController?
    public weak var parentCoordinator: (any IRCoordinatorProtocol)?
    public var children: [any IRCoordinatorProtocol] = []

    public init() {}

    open func start() -> UIViewController {
        fatalError("Must override start()")
    }

    open func startCoordinator(
        _ child: any IRCoordinatorProtocol,
        with method: CoordinatorPresentationMethod,
        animated: Bool,
        completion: IRVoidHandler? = nil
    ) {
        child.navigationController = (method == .push) ? navigationController : child.navigationControllerForPresentation()
        let initialVC = start(child)

        switch method {
        case .push:
            navigationController?.pushViewController(initialVC, animated: animated)
        case .present(let style):
            child.navigationController?.viewControllers = [initialVC]
            child.navigationController?.modalPresentationStyle = style
            navigationController?.present(child.navigationController!, animated: animated, completion: completion)
        }
    }

    public func start(with window: UIWindow?) {
        let navController = navigationControllerForPresentation()
        self.navigationController = navController
        navController.viewControllers = [start()]
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    deinit {
        debugPrint("deinit: \(self)")
    }
}
