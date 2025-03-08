//
//  Deneme.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 8.03.2025.
//

import Foundation
import UIKit

// MARK: - Protocols
protocol DisplayableItem {
    var identifier: String { get }
    func configure(_ view: UIView)
}

// MARK: - Base Table & Collection View Controller
class UnifiedListViewController: UIViewController {

    var sections: [[DisplayableItem]] = [] {
        didSet {
            registerCells()
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [tableView, collectionView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func registerCells() {
        let allItems = sections.flatMap { $0 }
        allItems.forEach { item in
            tableView.register(TextCell.self, forCellReuseIdentifier: item.identifier)
            collectionView.register(CollectionTextCell.self, forCellWithReuseIdentifier: item.identifier)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension UnifiedListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        item.configure(cell)
        return cell
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension UnifiedListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int { sections.count }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { sections[section].count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section][indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.identifier, for: indexPath)
        item.configure(cell)
        return cell
    }
}

// MARK: - Custom Cells
class TextCell: UITableViewCell {
    func configure(with text: String) { textLabel?.text = text }
}

class CollectionTextCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with text: String) { label.text = text }
}

// MARK: - DisplayableItem Implementations
struct TextCellItem: DisplayableItem {
    let text: String

    var identifier: String { "TextCell" }

    func configure(_ view: UIView) {
        if let cell = view as? TextCell {
            cell.configure(with: text)
        } else if let cell = view as? CollectionTextCell {
            cell.configure(with: text)
        }
    }
}

// MARK: - Usage Example
class ViewController: UnifiedListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            [TextCellItem(text: "Hello"), TextCellItem(text: "World")],
            [TextCellItem(text: "Swift"), TextCellItem(text: "iOS")]
        ]
    }
}
