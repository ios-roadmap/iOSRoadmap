//
//  SearchController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 15.04.2025.
//

import UIKit

@MainActor
public protocol CustomSearchControllerDelegate: AnyObject {
    func searchDidUpdate(query: String)
    func searchDidCancel()
}

@MainActor
public final class CustomSearchController: NSObject {
    public let searchController: UISearchController
    public weak var delegate: CustomSearchControllerDelegate?

    public init(placeholder: String = "Search") {
        self.searchController = UISearchController(searchResultsController: nil)
        super.init()
        configure(placeholder: placeholder)
    }

    private func configure(placeholder: String) {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = placeholder
        searchController.searchBar.autocapitalizationType = .none
    }
}

extension CustomSearchController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        delegate?.searchDidUpdate(query: query)
    }
}

extension CustomSearchController: UISearchBarDelegate {
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchDidCancel()
    }
}
