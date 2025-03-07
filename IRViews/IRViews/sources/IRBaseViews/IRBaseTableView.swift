//
//  BaseTableViewController.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 7.03.2025.
//

import UIKit
import IRCommon

open class IRBaseTableView<Cell: UITableViewCell & IRConfigurableCellProtocol>: UIViewController, UITableViewDataSource, UITableViewDelegate where Cell.DataType: Any {
    
    lazy var baseTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    open var tableViewSections: [IRConfigurableViewSection<Cell.DataType>] = [] {
        didSet {
            registerCells()
            baseTableView.reloadData()
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        baseTableView.delegate = self
        baseTableView.dataSource = self
        view.addSubview(baseTableView)
        
        NSLayoutConstraint.activate([
            baseTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            baseTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            baseTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            baseTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func registerCells() {
        baseTableView.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    // MARK: - UITableViewDataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSections[section].items.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableViewSections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
        cell.configure(with: data)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSections[section].header
    }
}
