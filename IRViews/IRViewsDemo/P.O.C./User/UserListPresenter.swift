//
//  UserListPresenter.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 5.03.2025.
//

import Foundation

class UserListPresenter {
    weak var viewController: UserListViewController?
    
    func presentUsers(users: [User]) {
        viewController?.displayUsers(users: users)
    }
}
