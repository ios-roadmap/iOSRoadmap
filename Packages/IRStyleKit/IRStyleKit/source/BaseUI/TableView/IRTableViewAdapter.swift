//
//  IRTableViewAdapter.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

@MainActor
public final class IRTableViewAdapter: NSObject {
    private weak var tableView: UITableView?
    private var sections: [IRTableSection] = []
    private var registeredCells: Set<String> = []
    private var isPaginating = false

    public var onScrollToBottom: (() -> Void)?

    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        print("[Adapter] Adapter initialized")
    }

    public func update(sections: [IRTableSection]) {
        print("[Adapter] Updating with \(sections.count) sections")
        self.sections = sections
        registerCells()
        tableView?.reloadData()
    }

    private func registerCells() {
        sections
            .flatMap { $0.items }
            .forEach { item in
                let id = item.reuseIdentifier
                guard !registeredCells.contains(id) else { return }
                print("[Adapter] Registering cell: \(id)")
                tableView?.register(type(of: item).cellClass, forCellReuseIdentifier: id)
                registeredCells.insert(id)
            }
    }

    private func viewModel(at indexPath: IndexPath) -> IRCellViewModelProtocol {
        sections[indexPath.section].items[indexPath.row]
    }

    private func baseViewModel(at indexPath: IndexPath) -> IRBaseCellViewModel? {
        viewModel(at: indexPath) as? IRBaseCellViewModel
    }
}

// MARK: - UITableViewDataSource

extension IRTableViewAdapter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModel(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier, for: indexPath)
        if let baseCell = cell as? IRBaseCell {
            viewModel.configure(cell: baseCell)
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.tableHeaderView?.backgroundColor = .red
        if case let .title(title) = sections[section].header {
            return title
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if case let .view(view) = sections[section].header {
            return view
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if case let .view(view) = sections[section].footer {
            return view
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //TODO: Set Color From Asset
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .white
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        // TODO: Set Color From Asset
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .white
    }

}

// MARK: - UITableViewDelegate

extension IRTableViewAdapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("[Adapter] Row selected at \(indexPath)")
        baseViewModel(at: indexPath)?.onSelect?()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    public func tableView(_ tableView: UITableView,
                          trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let swipeActions = baseViewModel(at: indexPath)?.swipeActions else { return nil }
        let actions = swipeActions.map { $0.toContextualAction() }
        return actions.isEmpty ? nil : UISwipeActionsConfiguration(actions: actions)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = self.tableView else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = tableView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100, !isPaginating {
            print("[Adapter] Near bottom of scrollView. Triggering onScrollToBottom.")
            isPaginating = true
            DispatchQueue.main.async { [weak self] in
                self?.onScrollToBottom?()
                self?.isPaginating = false
            }
        }
    }
}

// MARK: - Prefetching

extension IRTableViewAdapter: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            print("[Adapter] Prefetching row at \($0)")
            baseViewModel(at: $0)?.onPrefetch?()
        }
    }
}
