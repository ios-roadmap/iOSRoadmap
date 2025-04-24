//
//  JPHUserListContracts.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 21.04.2025.
//

import UIKit

@MainActor
public protocol JPHUserListInteractorLogic: AnyObject {
    func fetchUserList()
}

@MainActor
public protocol JPHUserListPresenterLogic: AnyObject {
    func presentUserList(_ result: Result<[JPHUserListEntity.User], Error>)
}

@MainActor
public protocol JPHUserListViewControllerLogic: AnyObject {
    func displayUserList(usersNames: [JPHUserListEntity.User])
    func display(error message: String)
}

@MainActor
protocol JPHUserListRouterLogic {
    func navigateToDetail(from vc: UIViewController, user: JPHUserListEntity.User)
}
