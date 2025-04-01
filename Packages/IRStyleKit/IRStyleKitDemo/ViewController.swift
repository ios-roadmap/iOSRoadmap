//
//  ViewController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 26.03.2025.
//

import UIKit
import IRBase
import IRStyleKit

final class ViewController: IRViewController {

    private let tableView = IRTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }

    private func configureTable() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.delegate = self

        let section1 = IRTableViewSectionBuilder("Sample")
            .add(.spacer(16, .blue))
            .add(.spacer(16, .yellow))
            .build()

        let section2 = IRTableViewSectionBuilder()
            .add(.spacer(16, .red))
            .add(.spacer(16, .white))
            .add(.spacer(16, .green))
            .build()

        tableView.update(sections: [section1, section2])
    }
}

extension ViewController: IRTableViewDelegate {
    func didSelect(item: any IRTableViewItemProtocol, at indexPath: IndexPath) {
        print("Tapped: \(item.cellClass) @ \(indexPath)")
    }
}
