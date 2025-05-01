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
    private let navigator: NavigationLogic
    
    init(interactor: JPHUserListInteractorLogic, navigator: NavigationLogic) {
        self.interactor = interactor
        self.navigator = navigator
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
        let items: [BaseCellViewModel] = usersNames.map { user in
            ConfigurableCellViewModel(name: (user.name)~, company: (user.phone)~) { [weak self] in
                guard let self else { return }
                self.navigator.navigateToDetail(from: self, user: user)
            }
        }
        let tv = TableView()
            .withSections([.init(items: items)])
        
        view.fit(tv)
    }
    
    //TODO: Burası customize olarak StyleKit'den gelmeli. Özel bir Alert çalışması. Farklı temalarla birlikte.
    func display(error message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
