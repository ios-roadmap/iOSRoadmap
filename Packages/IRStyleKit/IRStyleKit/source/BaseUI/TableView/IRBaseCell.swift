//
//  IRBaseCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

@MainActor
public protocol IRCellViewModelProtocol {
    static var cellClass: IRBaseCell.Type { get }
    var reuseIdentifier: String { get }
    func configure(cell: IRBaseCell)
}

open class IRBaseCellViewModel: IRCellViewModelProtocol {
    open class var cellClass: IRBaseCell.Type { IRBaseCell.self }
    open var reuseIdentifier: String { String(describing: Self.cellClass) }

    public let onSelect: (() -> Void)?
    public let onPrefetch: (() -> Void)?
    public let swipeActions: [IRSwipeAction]?
    public let isSelectionEnabled: Bool

    public init(
        onSelect: (() -> Void)? = nil,
        onPrefetch: (() -> Void)? = nil,
        swipeActions: [IRSwipeAction]? = nil,
        isSelectionEnabled: Bool = true
    ) {
        self.onSelect = onSelect
        self.onPrefetch = onPrefetch
        self.swipeActions = swipeActions
        self.isSelectionEnabled = isSelectionEnabled
    }

    open func configure(cell: IRBaseCell) {
        cell.bindViewModel(self)
    }
}

extension IRBaseCellViewModel {
    static func commonInitArgs(
        onSelect: (() -> Void)? = nil,
        onPrefetch: (() -> Void)? = nil,
        swipeActions: [IRSwipeAction]? = nil,
        isSelectionEnabled: Bool = true
    ) -> (onSelect: (() -> Void)?, onPrefetch: (() -> Void)?, swipeActions: [IRSwipeAction]?, isSelectionEnabled: Bool) {
        return (onSelect, onPrefetch, swipeActions, isSelectionEnabled)
    }
}


open class IRBaseCell: UITableViewCell {
    public private(set) var onSelect: (() -> Void)?
    public private(set) var swipeActions: [UIContextualAction]?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    open func setup() {
        // override only for UI setup
    }

    open func configureContent(with viewModel: IRBaseCellViewModel) {
        // override for specific content config
    }

    public func bindViewModel(_ viewModel: IRBaseCellViewModel) {
        self.onSelect = viewModel.onSelect
        self.swipeActions = viewModel.swipeActions?.map { $0.toContextualAction() }
        selectionStyle = viewModel.isSelectionEnabled ? .default : .none
        configureContent(with: viewModel)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        onSelect = nil
        swipeActions = nil
    }
}
