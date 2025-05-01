//
//  BaseCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit
import IRFoundation

// MARK: – Cell-ViewModel Contract
@MainActor
public protocol CellViewModelProtocol {
    static var cellClass: BaseCell.Type { get }
    var reuseIdentifier: String { get }
    func configure(cell: BaseCell)
}

// MARK: – Base Cell ViewModel
@MainActor
open class BaseCellViewModel: CellViewModelProtocol {
    open class var cellClass: BaseCell.Type { BaseCell.self }
    open var reuseIdentifier: String { String(describing: Self.cellClass) }

    public let onSelect      : VoidHandler?
    public let onPrefetch    : VoidHandler?
    public let swipeActions  : [TableSwipeAction]?
    public let isSelectable  : Bool

    public init(
        onSelect     : VoidHandler? = nil,
        onPrefetch   : VoidHandler? = nil,
        swipeActions : [TableSwipeAction]? = nil,
        isSelectable : Bool = true
    ) {
        self.onSelect     = onSelect
        self.onPrefetch   = onPrefetch
        self.swipeActions = swipeActions
        self.isSelectable = isSelectable
    }

    open func configure(cell: BaseCell) {
        cell.bind(viewModel: self)
    }
}

// MARK: – UITableViewCell Base
@MainActor
open class BaseCell: UITableViewCell {
    private(set) var swipeActions: [UIContextualAction]?

    public override init(style: UITableViewCell.CellStyle = .default,
                         reuseIdentifier: String? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { fatalError("init(coder:) is unsupported") }

    open func setup() { /* override for UI */ }
    open func configureContent(with viewModel: BaseCellViewModel) { /* override */ }

    public final func bind(viewModel: BaseCellViewModel) {
        swipeActions  = viewModel.swipeActions?.map { $0.toContextualAction() }
        selectionStyle = viewModel.isSelectable ? .default : .none
        configureContent(with: viewModel)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        swipeActions = nil
    }
}
