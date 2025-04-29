//
//  TableView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

@MainActor
public final class TableView: UITableView {

    // MARK: - Private state
    private var sections: [TableSection] = []
    private var registeredCells = Set<String>()
    private var isPaginating = false
    private var onScrollToBottom: (() -> Void)?

    // MARK: - Init
    public override init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) is unsupported")
    }

    // MARK: - Private
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        sectionHeaderTopPadding = 0
        dataSource         = self
        delegate           = self
        prefetchDataSource = self
    }

    private func registerMissingCells() {
        sections
            .flatMap(\.items)
            .forEach { vm in
                let id = vm.reuseIdentifier
                guard registeredCells.insert(id).inserted else { return }
                register(type(of: vm).cellClass, forCellReuseIdentifier: id)
            }
    }

    private func viewModel(at indexPath: IndexPath) -> CellViewModelProtocol {
        sections[indexPath.section].items[indexPath.row]
    }

    private func baseViewModel(at indexPath: IndexPath) -> BaseCellViewModel? {
        viewModel(at: indexPath) as? BaseCellViewModel
    }
}

// MARK: - Builder Extensions
extension TableView {
    
    @discardableResult
    public func withSections(_ sections: [TableSection]) -> Self {
        self.sections = sections
        registerMissingCells()
        reloadData()
        return self
    }

    @discardableResult
    public func withScrollToBottomHandler(_ handler: @escaping () -> Void) -> Self {
        self.onScrollToBottom = handler
        return self
    }
}

// MARK: - UITableViewDataSource
extension TableView: UITableViewDataSource {
    
    public func numberOfSections(in _: UITableView) -> Int {
        sections.count
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm   = viewModel(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.reuseIdentifier, for: indexPath)
        (cell as? BaseCell).map { vm.configure(cell: $0) }
        return cell
    }

    public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard case let .title(t) = sections[section].header else { return nil }
        return t
    }

    public func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section].header {
        case .none:        return nil
        case .title:       return nil
        case .view(let v): return v
        }
    }

    public func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        guard case let .title(t) = sections[section].footer else { return nil }
        return t
    }

    public func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch sections[section].footer {
        case .none:        return UIView()
        case .title:       return nil
        case .view(let v): return v
        }
    }
}

// MARK: - UITableViewDelegate
extension TableView: UITableViewDelegate {
    
    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        baseViewModel(at: indexPath)?.onSelect?()
        deselectRow(at: indexPath, animated: true)
    }

    public func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        guard let acts = baseViewModel(at: indexPath)?.swipeActions else { return nil }
        let config = UISwipeActionsConfiguration(actions: acts.map { $0.toContextualAction() })
        return config.actions.isEmpty ? nil : config
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diff = scrollView.contentSize.height - scrollView.bounds.height - scrollView.contentOffset.y
        guard diff < 100, !isPaginating else { return }
        isPaginating = true
        DispatchQueue.main.async { [weak self] in
            self?.onScrollToBottom?()
            self?.isPaginating = false
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension TableView: UITableViewDataSourcePrefetching {
    
    public func tableView(_: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { baseViewModel(at: $0)?.onPrefetch?() }
    }
}
