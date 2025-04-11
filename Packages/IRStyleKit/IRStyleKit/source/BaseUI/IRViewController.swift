//
//  IRViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

//backing storage design pattern
//Konu    Açıklama
///_tableView / _adapter      Lazy-internal state. tableView'a dışarıdan erişildiğinde yaratılır.
///onTableViewCreated         TableView oluşturulunca bir şey yapmak istersen override edersin.
///viewDidLoad                Bu yapı için pasif. Çünkü UI setup veri geldikçe şekillenir.
///Layout kontrolü            Eğer tam ekran değilse, layout subclass’a bırakılmalı.

open class IRViewController: UIViewController {
    private var _tableView: UITableView?
    private var _adapter: IRTableViewAdapter?
    private var didApplyCustomConstraints = false
    private var isRefreshDataOverridden: Bool {
        let base = class_getInstanceMethod(IRViewController.self, #selector(refreshData))
        let current = class_getInstanceMethod(type(of: self), #selector(refreshData))
        return base != current
    }

    /// Lazy-loaded tableView. İlk erişimde yaratılır.
    private var tableView: UITableView {
        if _tableView == nil {
            print("[BaseVC] Creating tableView")
            let tv = createTableView()
            _tableView = tv
            view.addSubview(tv)
            _adapter = makeAdapter(for: tv)

            onTableViewCreated(tv)

            if !didApplyCustomConstraints {
                print("[BaseVC] Applying default constraints")
                applyDefaultConstraints(to: tv)
            }
        }
        return _tableView!
    }

    /// Lazy adapter. TableView oluşturulduğunda kurulur.
    public var adapter: IRTableViewAdapter? {
        _ = tableView // create on access
        return _adapter
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("[BaseVC] viewDidLoad")
        setup()
    }

    open func setup() {
        // Alt sınıflar UI setup'larını buraya yazar
    }

    /// Alt sınıf, tableView yaratıldıktan sonra kendi constraint'ini verebilir
    open func onTableViewCreated(_ tableView: UITableView) {
        // Alt sınıf override eder
    }

    public func markCustomTableViewConstraintsApplied() {
        didApplyCustomConstraints = true
    }

    /// TableView default ayarları burada tanımlanır
    private func createTableView() -> UITableView {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .singleLine
        tv.backgroundColor = .clear
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 60
        tv.keyboardDismissMode = .onDrag
        tv.showsVerticalScrollIndicator = true
        tv.sectionHeaderTopPadding = 0
        if isRefreshDataOverridden {
            tv.refreshControl = makeRefreshControl()
        }
        return tv
    }

    private func applyDefaultConstraints(to tableView: UITableView) {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func makeAdapter(for tableView: UITableView) -> IRTableViewAdapter {
        let adapter = IRTableViewAdapter(tableView: tableView)
        adapter.onScrollToBottom = { [weak self] in
            print("[BaseVC] Triggered scroll to bottom")
            self?.loadNextPage()
        }
        return adapter
    }

    private func makeRefreshControl() -> UIRefreshControl {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }

    public func update(sections: [IRTableSection]) {
        print("[BaseVC] Updating sections: \(sections.count)")
        adapter?.update(sections: sections)
    }

    public func endRefreshing() {
        print("[BaseVC] Ending refresh")
        tableView.refreshControl?.endRefreshing()
    }

    open func loadNextPage() {
        // Override by subclass
    }

    @objc open func refreshData() {
        // Override by subclass
    }
}
