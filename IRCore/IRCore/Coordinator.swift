//
//  Coordinator.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//

import UIKit

public protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: CoordinatorProtocol? { get set }
    
    @discardableResult
    func start() -> UINavigationController?
    
    @discardableResult
    func start(_ coordinator: CoordinatorProtocol) -> UIViewController?
    
    var children: NSHashTable<AnyObject> { get set }
    
    func startCoordinatorWithPush(
        _ coordinator: CoordinatorProtocol,
        modelPresentationStyle: UIModalPresentationStyle?,
        animated: Bool,
        completion: (() -> Void)?
    )
    
    func start(with window: UIWindow)
    
    func navigationControllerForPresentation() -> UINavigationController?
}

public extension CoordinatorProtocol {
    func start(_ coordinator: CoordinatorProtocol) -> UIViewController? {
        print("child: \(coordinator) add to the parent: \(self)")
        children.add(coordinator)
        coordinator.parentCoordinator = self
        return coordinator.start()
    }
    
    func startCoordinatorWithPush(
        _ coordinator: CoordinatorProtocol,
        modelPresentationStyle: UIModalPresentationStyle?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        
    }
    
    func start(with window: UIWindow) {
        
    }
    
    func navigationControllerForPresentation() -> UINavigationController? {
        return UINavigationController()
    }
}
