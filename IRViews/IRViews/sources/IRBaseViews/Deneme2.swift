//
//  Deneme2.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 8.03.2025.
//

import UIKit

// MARK: - Protocols
protocol TableViewItem {
    var cellClass: UITableViewCell.Type { get }
    func configureCell(_ cell: UITableViewCell)
}

protocol TableViewSection {
    var headerView: UIView? { get }
    var items: [TableViewItem] { get set }
}

// MARK: - Base TableViewController
class BaseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sections: [TableViewSection] = [] {
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func registerCells(for newItems: [TableViewItem]) {
        var registeredCellTypes: [String: Bool] = [:]

        newItems.forEach { item in
            let identifier = String(describing: item.cellClass)
            if registeredCellTypes[identifier] == nil {
                tableView.register(item.cellClass, forCellReuseIdentifier: identifier)
                registeredCellTypes[identifier] = true
            }
        }
    }
    
    // MARK: - TableView DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let identifier = String(describing: item.cellClass)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        item.configureCell(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].headerView
    }
}

// MARK: - Custom Cell Implementations
class TextCell: UITableViewCell {
    func configure(with text: String) {
        textLabel?.text = text
    }
}

class ImageCell: UITableViewCell {
    func configure(with imageName: String) {
        imageView?.image = UIImage(named: imageName)
    }
}

// MARK: - TableViewItem Implementations
struct TextCellItem: TableViewItem {
    let text: String

    var cellClass: UITableViewCell.Type { TextCell.self }

    func configureCell(_ cell: UITableViewCell) {
        (cell as? TextCell)?.configure(with: text)
    }
}

struct ImageCellItem: TableViewItem {
    let imageName: String

    var cellClass: UITableViewCell.Type { ImageCell.self }

    func configureCell(_ cell: UITableViewCell) {
        (cell as? ImageCell)?.configure(with: imageName)
    }
}

// MARK: - TableViewSection Implementation
struct CustomSection: TableViewSection {
    var headerView: UIView?
    var items: [TableViewItem]
}

class ViewController: BaseTableViewController {
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Item", for: .normal)
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let section1 = CustomSection(
            headerView: UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50)),
            items: [TextCellItem(text: "Hello"), ImageCellItem(imageName: "icon")]
        )
        
        let section2 = CustomSection(
            headerView: nil,
            items: [TextCellItem(text: "World"), ImageCellItem(imageName: "photo")]
        )
        
        sections = [section1, section2]
        
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func addNewItem() {
        if sections.isEmpty {
            sections.append(CustomSection(headerView: nil, items: []))
        }
        
        sections[0].items.append(TextCellItem(text: "New Item"))
        sections = sections // Trigger didSet to reload tableView
    }
}
