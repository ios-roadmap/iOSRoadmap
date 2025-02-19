//
//  IRDashboardView.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//
 
import UIKit

public protocol IRDashboardViewProtocol: AnyObject {
    func showDashboardData(_ data: [IRDashboardItem])
}

public class IRDashboardView: UIViewController {
    
    public var presenter: IRDashboardPresenterProtocol?

    private var dashboardItems: [IRDashboardItem] = []

    private let tableView = UITableView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        title = "Dashboard"
        view.backgroundColor = .white

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

extension IRDashboardView: @preconcurrency IRDashboardViewProtocol {
    @MainActor
    public func showDashboardData(_ data: [IRDashboardItem]) {
        self.dashboardItems = data
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension IRDashboardView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = dashboardItems[indexPath.row]
        cell.textLabel?.text = "\(item.icon) \(item.title): \(item.value)"
        return cell
    }
}

