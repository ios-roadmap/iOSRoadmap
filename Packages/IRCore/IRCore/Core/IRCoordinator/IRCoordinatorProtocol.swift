//
//  Coordinator.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//

import UIKit

@MainActor
public protocol IRCoordinatorProtocol: Sendable {
    func start()
    func setupWindow(windowScene: UIWindowScene)
    func startChildCoordinator(
        _ coordinator: IRCoordinatorProtocol,
        with method: IRCoordinator.IRCoordinatorPresentationMethod,
        animated: Bool,
        completion: (() -> Void)?
    )
    func stopChildCoordinator()
}

open class IRCoordinator: IRCoordinatorProtocol {
    
    public var navigationController: UINavigationController?
    private let navigationDelegate = IRNavigationControllerDelegate()
    
    private weak var parentCoordinator: IRCoordinator?
    public var childCoordinator: IRCoordinator?
    
    public init(parent: IRCoordinator? = nil) {
        self.parentCoordinator = parent
    }
    
    public enum IRCoordinatorPresentationMethod: Equatable {
        case push
        case present(UIModalPresentationStyle = .automatic)
    }

    open func start() {
        fatalError("Subclasses should implement `start()`")
    }

    open func navigate(
        to viewController: UIViewController,
        with method: IRCoordinatorPresentationMethod = .push,
        animated: Bool = true
    ) {
        switch method {
        case .push:
            navigationController?.pushViewController(viewController, animated: animated)
        case .present(let style):
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = style
            navigationController?.present(navController, animated: animated)
        }
    }


    open func pop(animated: Bool = true) {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationController?.popViewController(animated: animated)
        } else {
            stopChildCoordinator()
        }
    }

    public var window: UIWindow?
    public func setupWindow(windowScene: UIWindowScene) {
        navigationController = UINavigationController()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        start()
    }

    public func startChildCoordinator(
        _ coordinator: IRCoordinatorProtocol,
        with method: IRCoordinatorPresentationMethod,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        guard let concreteCoordinator = coordinator as? IRCoordinator else {
            fatalError("Coordinator is not a subclass of IRCoreCoordinator")
        }

        // Koordinatörü Dependency Container’a strong olarak kaydediyoruz
        IRDependencyContainer.shared.register(IRCoordinator.self) { concreteCoordinator}
        
        switch method {
        case .push:
            concreteCoordinator.navigationController = self.navigationController
            concreteCoordinator.start()
        case .present(let style):
            let navController = UINavigationController(rootViewController: concreteCoordinator.navigationController!)
            navController.modalPresentationStyle = style
            self.navigationController?.present(navController, animated: animated)
        }
    }

    public func stopChildCoordinator() {
        childCoordinator?.navigationController?.dismiss(animated: true)

        // Dependency Container’dan koordinatörü kaldır
        if let coordinator = childCoordinator {
            IRDependencyContainer.shared.unregister(type(of: coordinator))
        }

        childCoordinator = nil
        IRDependencyContainer.shared.debugPrint()
    }
}
