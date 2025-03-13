//
//  BaseTableViewController.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 7.03.2025.
//

import UIKit
import SnapKit

open class IRViewsBaseTableViewController: UIViewController {
    
    public var sections: [IRViewsBaseTableSectionProtocol] = [] {
        didSet {
            let newItems = sections.flatMap { $0.items }
            registerCells(for: newItems)
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubviews(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func registerCells(for newItems: [IRViewsBaseTableItemProtocol]) {
        var registeredCellTypes = Set<String>()
        
        newItems.forEach { item in
            let identifier = String(describing: item.cellClass)
            if !registeredCellTypes.contains(identifier) {
                tableView.register(item.cellClass, forCellReuseIdentifier: identifier)
                registeredCellTypes.insert(identifier)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension IRViewsBaseTableViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let identifier = String(describing: item.cellClass)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? IRViewsBaseTableCell else {
            fatalError("Cell of type \(identifier) not registered or incorrect type.")
        }
        item.configureCell(cell)
        return cell
    }
}

extension IRViewsBaseTableViewController: UITableViewDelegate {
    
}
