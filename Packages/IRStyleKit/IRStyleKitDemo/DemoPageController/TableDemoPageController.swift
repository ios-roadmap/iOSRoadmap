//
//  TableDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import IRStyleKit
import UIKit
final class TableDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let action = TableSwipeAction(
            title: "Delete",
            style: .destructive,
            colour: .systemRed,
            image: .init(systemName: "trash")) {
                print("Delete tapped")
            }

        let items = [
            IRTextCellViewModel(text: "Lazy Load 1", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 2", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 3", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 4", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 5", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 6", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 7", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 8", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 9", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 10", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 11", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 12", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 13", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 14", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 15", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 16", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 17", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 18", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 19", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 20", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 21", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 22", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 23", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 24", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 25", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 26", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 27", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 28", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 29", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 30", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 31", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 32", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 33", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 34", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 35", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 36", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 37", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 38", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 39", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 40", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 41", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 42", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 43", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 44", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 45", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 46", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 47", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 48", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 49", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 50", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 51", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 52", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 53", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 54", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 55", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 56", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 57", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 58", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 59", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 60", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 61", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 62", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 63", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 64", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 65", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 66", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 67", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 68", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 69", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 70", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 71", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 72", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 73", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 74", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 75", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 76", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 77", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 78", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 79", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 80", swipeActions: [action]),
            IRTextCellViewModel(text: "Lazy Load 81", swipeActions: [action], isSelectionEnabled: false),
            IRTextCellViewModel(text: "Lazy Load 82", swipeActions: [action]),
        ]

        let section = TableSection(header: .title("Custom Layout"), items: items)
        let tv = TableView()
            .withSections([section])
        
        view.fit(tv)
    }
}
