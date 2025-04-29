//
//  TableView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

@MainActor
public final class TableView: UITableView {

    // MARK: Public surface
    public var onScrollToBottom: (() -> Void)?

    // MARK: Private state
    private var sections: [TableSection] = []
    private var registeredCells = Set<String>()
    private var isPaginating    = false

    // MARK: Init
    public init(style: UITableView.Style = .plain) {
        super.init(frame: .zero, style: style)
        commonInit()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { fatalError("init(coder:) is unsupported") }

    // MARK: Public API
    public func update(sections: [TableSection]) {
        self.sections = sections
        registerMissingCells()
        reloadData()
    }

    // MARK: Private
    private func commonInit() {
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

// MARK: – UITableViewDataSource
extension TableView: UITableViewDataSource {
    public func numberOfSections(in _: UITableView) -> Int { sections.count }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    public func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        let vm   = viewModel(at: ip)
        let cell = tv.dequeueReusableCell(withIdentifier: vm.reuseIdentifier, for: ip)
        (cell as? BaseCell).map { vm.configure(cell: $0) }
        return cell
    }

    public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard case let .title(t) = sections[section].header else { return nil }
        return t
    }

    public func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section].header {
        case .none:        return UIView()
        case .title:       return UIView()
        case .view(let v): return v
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard case let .title(t) = sections[section].footer else { return nil }
        return t
    }

    public func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch sections[section].footer {
        case .none:        return UIView()
        case .title:       return UIView()
        case .view(let v): return v
        }
    }
}

// MARK: – UITableViewDelegate
extension TableView: UITableViewDelegate {
    public func tableView(_: UITableView, didSelectRowAt ip: IndexPath) {
        baseViewModel(at: ip)?.onSelect?()
        deselectRow(at: ip, animated: true)
    }

    public func tableView(_: UITableView,
                          trailingSwipeActionsConfigurationForRowAt ip: IndexPath)
    -> UISwipeActionsConfiguration? {
        guard let acts = baseViewModel(at: ip)?.swipeActions else { return nil }
        let cfg = UISwipeActionsConfiguration(actions: acts.map { $0.toContextualAction() })
        return cfg.actions.isEmpty ? nil : cfg
    }

    public func scrollViewDidScroll(_ sv: UIScrollView) {
        // Infinity-scroll sentinel
        let diff = sv.contentSize.height - sv.bounds.height - sv.contentOffset.y
        guard diff < 100, !isPaginating else { return }
        isPaginating = true
        DispatchQueue.main.async { [weak self] in
            self?.onScrollToBottom?()
            self?.isPaginating = false
        }
    }
}

// MARK: – Prefetching
extension TableView: UITableViewDataSourcePrefetching {
    public func tableView(_: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { baseViewModel(at: $0)?.onPrefetch?() }
    }
}
