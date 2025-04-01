//
//  IRTableView.swift
//  IRBase
//
//  Created by Ömer Faruk Öztürk on 26.03.2025.
//

import UIKit

public protocol IRTableViewDelegate: AnyObject {
    func didSelect(item: IRTableViewItemProtocol, at indexPath: IndexPath)
}

public final class IRTableView: UIView {

    public weak var delegate: IRTableViewDelegate?
    private var sections: [IRTableViewSectionProtocol] = []

    public private(set) lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        return tv
    }()

    public func update(sections: [IRTableViewSectionProtocol]) {
        DispatchQueue.main.async {
            self.registerCells(for: sections.flatMap(\.items))
            self.sections = sections
            self.tableView.reloadData()
        }
    }

    private func registerCells(for items: [IRTableViewItemProtocol]) {
        var registered = Set<String>()
        items.forEach {
            let id = String(describing: $0.cellClass)
            guard !registered.contains(id) else { return }
            tableView.register($0.cellClass, forCellReuseIdentifier: id)
            registered.insert(id)
        }
    }
}

// MARK: - UITableViewDataSource
extension IRTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let id = String(describing: item.cellClass)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? IRTableViewCell else {
            fatalError("Missing cell: \(id)")
        }
        item.configureCell(cell)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension IRTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        delegate?.didSelect(item: item, at: indexPath)
    }
}
