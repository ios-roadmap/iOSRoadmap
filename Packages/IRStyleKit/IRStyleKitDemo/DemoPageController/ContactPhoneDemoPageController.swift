//
//  ContactPhoneDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 14.04.2025.
//

import IRStyleKit
import UIKit

final class ContactPhoneDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {
    
    private let customSearch = CustomSearchController(placeholder: "Search users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()

        let items: [BaseCellViewModel] = [
            ConfigurableCellViewModel(
                name: "Leanne Graham",
                company: "@Bret",
                swipeActions: [
                    .init(
                        title: "Call Leanne",
//                        style: .destructive,
                        colour: .orange,
//                        image: .init(systemName: "person"),
                        handler: {
                            print("☎️ Call Leanne")
                        }
                    )
                ],
                isSelectable: false
            ),
            ConfigurableCellViewModel(
                name: "Clementine Bauch",
                company: "@Karlanne",
                onSelect: { print("ÖMER FARUK") }
            )
        ]


        let section = TableSection(header: .title("Contact Phone"), items: items)
        
        let tv = TableView()
            .withSections([section])
        
        view.fit(tv)
    }
    
    
    private func setupSearchBar() {
        navigationItem.searchController = customSearch.searchController
        customSearch.delegate = self
    }
}

extension ContactPhoneDemoPageController: CustomSearchControllerDelegate {
    func searchDidUpdate(query: String) {
        print("Search query: \(query)")
    }

    func searchDidCancel() {
        print("Search cancelled")
    }
}

//extension ContactPhoneDemoPageController: SegmentViewDelegate {
//    func segmentView(_ segmentView: SegmentView, didSelect index: Int) {
//        print("Selected segment at index: \(index)")
//    }
//}
