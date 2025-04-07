//
//  SpacerDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit
import IRStyleKit

final class SpacerDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    private let stackView = UIStackView()
    private let dynamicSpacer = IRSpacerView()
    private let conditionalSpacer = IRSpacerView()

    private let bottomTableViewHeight: CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        simulateDynamicUpdate()
        loadSpacerCellTestData()
    }

    override func setup() {
        view.backgroundColor = .systemBackground

        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Case'ler
        let fixedSpacer = IRSpacerView()
        fixedSpacer.configure(height: 16)
        stackView.addArrangedSubview(fixedSpacer)

        dynamicSpacer.configure(height: 8)
        stackView.addArrangedSubview(dynamicSpacer)

        let colouredSpacer = IRSpacerView()
        colouredSpacer.configure(height: 20, backgroundColor: .systemRed)
        stackView.addArrangedSubview(colouredSpacer)

        let standaloneSpacer = IRSpacerView()
        standaloneSpacer.configure(height: 40, backgroundColor: .systemBlue)
        view.addSubview(standaloneSpacer)
        NSLayoutConstraint.activate([
            standaloneSpacer.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            standaloneSpacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            standaloneSpacer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        conditionalSpacer.configure(height: 16)
        stackView.addArrangedSubview(conditionalSpacer)
        conditionalSpacer.isHidden = false
    }

    private func simulateDynamicUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dynamicSpacer.configure(height: 60)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.conditionalSpacer.isHidden = true
        }
    }

    override func onTableViewCreated(_ tableView: UITableView) {
        markCustomTableViewConstraintsApplied()

        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: bottomTableViewHeight),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func loadSpacerCellTestData() {
        let sections: [IRTableSection] = [
            IRTableSection(header: .title("TableView"), items: [
                IRSpacerCellViewModel(height: 20, backgroundColor: .systemGray5),
                IRSpacerCellViewModel(height: 40, backgroundColor: .systemGreen),
                IRSpacerCellViewModel(height: 80, backgroundColor: .systemBlue)
            ])
        ]
        update(sections: sections)
    }
}
