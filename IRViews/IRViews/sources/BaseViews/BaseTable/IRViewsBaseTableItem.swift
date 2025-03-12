//
//  IRViewsBaseTableViewCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 11.03.2025.
//

import UIKit

open class IRViewsBaseTableCell: UITableViewCell {
    open func configure(with item: IRViewsBaseTableItemProtocol) {}
}

public protocol IRViewsBaseTableCellViewModelProtocol {
    associatedtype CellType: IRViewsBaseTableCell
    func configure(_ cell: CellType)
}

public protocol IRViewsBaseTableItemProtocol {
    var cellClass: IRViewsBaseTableCell.Type { get }
    func configureCell(_ cell: IRViewsBaseTableCell)
}

struct IRViewsBaseTableItem<Cell: IRViewsBaseTableCell,
                            ViewModel: IRViewsBaseTableCellViewModelProtocol>: IRViewsBaseTableItemProtocol where ViewModel.CellType == Cell {
    
    public let viewModel: ViewModel
    public var cellClass: IRViewsBaseTableCell.Type { Cell.self }
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public func configureCell(_ cell: IRViewsBaseTableCell) {
        (cell as? Cell).map(viewModel.configure)
    }
}
