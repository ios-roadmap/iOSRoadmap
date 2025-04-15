//
//  IRJPHUserListViewController.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit
import IRStyleKit
import IRNetworking

final class IRJPHUserListViewController: IRViewController {
    
    var presenter: IRJPHUserListPresenterProtocol?

    override func setup() {
        super.setup()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "My Contacts"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension IRJPHUserListViewController: IRJPHUserListViewProtocol {
    func showUsers(_ users: [IRJPHUser]) {
        let items: [IRTextCellViewModel] = users.map { user in
            IRTextCellViewModel(text: user.name ?? "", onSelect: { [weak self] in
                self?.presenter?.didSelectUser(user)
            })
        }

        update(sections: [.init(items: items)])
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
