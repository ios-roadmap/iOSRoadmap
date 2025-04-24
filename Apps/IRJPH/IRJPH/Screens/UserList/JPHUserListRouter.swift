//
//  JPHUserListRouter.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 21.04.2025.
//

import UIKit

@MainActor
enum JPHUserListBuild {
    static func build(with model: JPHUserListEntity.Build) -> JPHUserListViewController {
        let presenter = JPHUserListPresenter()
        let interactor = JPHUserListInteractor(presenter: presenter, data: model.data)
        let view = JPHUserListViewController(interactor: interactor, navigator: model.navigator)
        presenter.view = view
        return view
    }
}
