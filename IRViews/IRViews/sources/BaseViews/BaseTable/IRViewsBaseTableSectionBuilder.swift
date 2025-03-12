//
//  IRBaseCollectionViewCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 7.03.2025.
//

import UIKit

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

public class IRViewsBaseTableSectionBuilder {
    private var headerTitle: String?
    private var items: [IRViewsBaseTableItemProtocol] = []

    public init(_ headerTitle: String? = nil) {
        self.headerTitle = headerTitle
    }

    public func add<T: IRViewsBaseTableCellViewModelProtocol>(_ viewModel: T) -> Self {
        let item = IRViewsBaseTableItem<T.CellType, T>(viewModel: viewModel)
        items.append(item)
        return self
    }

    public func build() -> IRViewsBaseTableSection {
        IRViewsBaseTableSection(headerTitle: headerTitle, items: items)
    }
}
