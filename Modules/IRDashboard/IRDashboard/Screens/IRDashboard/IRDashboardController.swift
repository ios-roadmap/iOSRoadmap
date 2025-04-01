//
//  IRDashboardController.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 13.03.2025.
//

import UIKit

import IRCore
import IRStyleKit
import IRBase

final class IRDashboardController: IRViewController {
    
    var navigator: IRDashboardNavigationLogic!
    
    lazy var tableView = IRTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let section = IRTableViewSectionBuilder()
            .add(.spacer(50, .red))
            .build()
        
        tableView.update(sections: [section])
        tableView.backgroundColor = .green
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

    }
}


