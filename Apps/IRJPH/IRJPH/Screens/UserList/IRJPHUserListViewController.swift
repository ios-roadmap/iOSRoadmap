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
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func setup() {
        super.setup()
        
        title = "Users"
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loadingIndicator.hidesWhenStopped = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    func showLoading(_ isLoading: Bool) {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }

    func showUsers(_ users: [IRJPHUser]) {
        let items: [IRTextCellViewModel] = users.map { user in
            IRTextCellViewModel(text: user.name ?? "", onSelect: { [weak self] in
                self?.presenter?.didSelectUser(user)
            })
        }

        update(sections: [.init(items: items)])
    }

    func showError(_ message: String) {
        loadingIndicator.stopAnimating()
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
