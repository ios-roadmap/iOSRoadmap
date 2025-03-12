//
//  IRDashboardViewController.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//
 
import UIKit
import IRViews

public class IRDashboardViewController: IRViewsBaseTableViewController {
    
    public var presenter: IRDashboardPresenterProtocol?

    private var dashboardItems: [IRDashboardItem] = []

    public override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
//        presenter?.viewDidLoad()
        sections = [
            IRViewsBaseTableSectionBuilder()
                .add(IRViewsHorizontalTitlesCellViewModel(titles: ["Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer"]))
                .build()
        ]
    }

    private func setupUI() {
        title = "Dashboard"
        view.backgroundColor = .white
    }
}

extension IRDashboardViewController: IRDashboardViewProtocol {
    public func showDashboardData(_ data: [IRDashboardItem]) {
        self.dashboardItems = data

//        tableView.reloadData()
    }
}

//// MARK: - UITableViewDataSource
//extension IRDashboardViewController: UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dashboardItems.count
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let item = dashboardItems[indexPath.row]
//        cell.textLabel?.text = "\(item.icon) \(item.title): \(item.value)"
//        return cell
//    }
//}

