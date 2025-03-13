//
//  IRViewsBaseTableViewCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 11.03.2025.
//

import UIKit

@MainActor
public protocol IRViewsBaseTableSectionProtocol {
    var headerView: UIView? { get }
    var headerTitle: String? { get }
    var items: [IRViewsBaseTableItemProtocol] { get set }
}

public struct IRViewsBaseTableSection: IRViewsBaseTableSectionProtocol {
    public var headerView: UIView?
    public var headerTitle: String?
    public var items: [IRViewsBaseTableItemProtocol]
    
    public init(headerTitle: String? = nil, headerView: UIView? = nil, items: [IRViewsBaseTableItemProtocol]) {
        self.headerTitle = headerTitle
        self.headerView = headerView
        self.items = items
    }
}

@MainActor
public class IRViewsBaseTableSectionBuilder {
    private var headerTitle: String?
    private var items: [IRViewsBaseTableItemProtocol] = []

    public init(_ headerTitle: String? = nil) {
        self.headerTitle = headerTitle
    }
    
    public func add(_ item: IRViewsTableSectionItem) -> Self {
        items.append(item.toItem())
        return self
    }
    
    public func build() -> IRViewsBaseTableSection {
        IRViewsBaseTableSection(headerTitle: headerTitle, items: items)
    }
}

@MainActor
public protocol IRViewsBaseTableCellViewModelProtocol {
    associatedtype CellType: IRViewsBaseTableCell
    func configure(_ cell: CellType)
}

@MainActor
public protocol IRViewsBaseTableItemProtocol {
    var cellClass: IRViewsBaseTableCell.Type { get }
    func configureCell(_ cell: IRViewsBaseTableCell)
}

public struct IRViewsBaseTableItem<Cell: IRViewsBaseTableCell, ViewModel: IRViewsBaseTableCellViewModelProtocol>: IRViewsBaseTableItemProtocol where ViewModel.CellType == Cell {
    public let viewModel: ViewModel
    public var cellClass: IRViewsBaseTableCell.Type { Cell.self }
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public func configureCell(_ cell: IRViewsBaseTableCell) {
        (cell as? Cell).map(viewModel.configure)
    }
}
