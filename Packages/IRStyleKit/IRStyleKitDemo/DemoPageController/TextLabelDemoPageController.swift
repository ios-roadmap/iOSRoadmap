//
//  TextLabelDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit
import IRStyleKit

final class TextLabelDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {
    
    private lazy var stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTextCellTestData()
    }
    
    override func setup() {
        let textLabelView = IRTextLabelView()
        textLabelView.configure(text: "Omer Faruk")
        stackView.addArrangedSubview(textLabelView)

        
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    override func onTableViewCreated(_ tableView: UITableView) {
        markCustomTableViewConstraintsApplied()

        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 400),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func loadTextCellTestData() {
        let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla porta, velit in sodales cursus, enim."
        let moreText = "Phasellus rutrum eu elit id convallis. Quisque posuere libero in sapien sodales lacinia."

        let sections: [IRTableSection] = [
            IRTableSection(header: .title("TableView"), items: [
                IRTextCellViewModel(text: "Just a short label"),
                IRTextCellViewModel(text: lorem),
                IRTextCellViewModel(text: "\(lorem)\n\(moreText)"),
                IRTextCellViewModel(text: "🧪 Unicode test: ✓ © ™ 🚀"),
                IRTextCellViewModel(text: "Multiline\nlabel\nwith\nspacing")
            ])
        ]

        update(sections: sections)
    }
}
