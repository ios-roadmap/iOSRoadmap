//
//  JPHUserListViewController.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 21.04.2025.
//

import UIKit
import IRStyleKit
import IRFoundation

final class JPHUserListViewController: IRViewController, JPHUserListViewControllerLogic {
    
    private let interactor: JPHUserListInteractorLogic
    
    init(interactor: JPHUserListInteractorLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Users"
        view.backgroundColor = .systemBackground
        interactor.fetchUserList()
    }
    
    func displayUserList(usersNames: [JPHUserListEntity.User]) {
        let items: [IRBaseCellViewModel] = usersNames.map { user in
            //TODO: Builder'dan beslenmeli.
            ContactPhoneCellViewModel(name: (user.name)~, phone: (user.phone)~, avatar: .checkmark) {
                JPHUserListRouter.navigateToDetail(from: self, user: user)
            }
        }
        
        update(sections: [.init(items: items)])
    }
    
    //TODO: Burası customize olarak StyleKit'den gelmeli. Özel bir Alert çalışması. Farklı temalarla birlikte.
    func display(error message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
