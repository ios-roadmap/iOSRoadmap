//
//  IRTableViewItem.swift
//  IRBase
//
//  Created by Ömer Faruk Öztürk on 26.03.2025.
//

import UIKit

@MainActor
public protocol IRTableViewSectionProtocol {
    var headerView: UIView? { get }
    var headerTitle: String? { get }
    var items: [IRTableViewItemProtocol] { get set }
}

public struct IRTableViewSection: IRTableViewSectionProtocol {
    public var headerView: UIView?
    public var headerTitle: String?
    public var items: [IRTableViewItemProtocol]
    
    public init(headerTitle: String? = nil, headerView: UIView? = nil, items: [IRTableViewItemProtocol]) {
        self.headerTitle = headerTitle
        self.headerView = headerView
        self.items = items
    }
}

@MainActor
public protocol IRTableViewCellViewModelProtocol {
    associatedtype CellType: IRTableViewCell
    func configure(_ cell: CellType)
}

@MainActor
public protocol IRTableViewItemProtocol {
    var cellClass: IRTableViewCell.Type { get }
    func configureCell(_ cell: IRTableViewCell)
}

public struct IRTableViewItem<Cell: IRTableViewCell,
                                   ViewModel: IRTableViewCellViewModelProtocol>: IRTableViewItemProtocol where ViewModel.CellType == Cell {
    public let viewModel: ViewModel
    public var cellClass: IRTableViewCell.Type { Cell.self }
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public func configureCell(_ cell: IRTableViewCell) {
        (cell as? Cell).map(viewModel.configure)
    }
}
