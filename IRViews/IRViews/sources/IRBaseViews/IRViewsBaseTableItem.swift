//
//  IRViewsBaseTableViewCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 11.03.2025.
//

import UIKit

open class IRViewsBaseTableViewCell: UITableViewCell {
    open func configure(with item: IRViewsBaseTableItemProtocol) {}
}

public protocol IRViewsBaseTableViewModelCellProtocol {
    associatedtype CellType: IRViewsBaseTableViewCell
    func configure(_ cell: CellType)
}

public protocol IRViewsBaseTableItemProtocol {
    var cellClass: IRViewsBaseTableViewCell.Type { get }
    func configureCell(_ cell: IRViewsBaseTableViewCell)
}

struct IRViewsBaseTableItem<Cell: IRViewsBaseTableViewCell,
                            ViewModel: IRViewsBaseTableViewModelCellProtocol>: IRViewsBaseTableItemProtocol where ViewModel.CellType == Cell {
    
    public let viewModel: ViewModel
    public var cellClass: IRViewsBaseTableViewCell.Type { Cell.self }
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public func configureCell(_ cell: IRViewsBaseTableViewCell) {
        (cell as? Cell).map(viewModel.configure)
    }
}
