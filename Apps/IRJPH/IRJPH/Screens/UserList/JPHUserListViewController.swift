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

    private let segmentView = SegmentView(segments: [
        .init(title: "All"),
        .init(title: "Favourites")
    ])
    
    private let tableView = TableView()

    // MARK: - Init
    
    init(interactor: JPHUserListInteractorLogic, navigator: NavigationLogic) {
        self.interactor = interactor
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Users"
        view.backgroundColor = .systemBackground
        
        setupSegmentView()
        setupTableView()

        interactor.fetchUserList()
    }

    // MARK: - Layout

    private func setupSegmentView() {
        segmentView.onSelectionChanged = { index in
            print("Selected segment: \(index)")
        }

        view.addSubview(segmentView)
        NSLayoutConstraint.activate([
            segmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Display Logic

    func displayUserList(usersNames: [JPHUserListEntity.User]) {
        let items: [BaseCellViewModel] = usersNames.map { user in
            ConfigurableCellViewModel(name: (user.name)~, company: (user.phone)~) { [weak self] in
                guard let self else { return }
                self.navigator.navigateToDetail(from: self, user: user)
            }
        }

        tableView.withSections([.init(items: items)])
    }

    // MARK: - Error Handling

    func display(error message: String) {
        // TODO: Replace with StyleKit Alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
