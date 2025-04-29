//
//  IRTextLabelCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit

public final class IRTextCell: BaseCell {
    
    private lazy var labelView = TextLabel()

    public override func setup() {
        super.setup()
        contentView.addSubview(labelView)

        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    public override func configureContent(with viewModel: BaseCellViewModel) {
        guard let viewModel = viewModel as? IRTextCellViewModel else { return }
        
        labelView
            .withText(viewModel.text)
    }
}

public final class IRTextCellViewModel: BaseCellViewModel {
    public override class var cellClass: BaseCell.Type { IRTextCell.self }

    public let text: String

    public init(
        text: String,
        onSelect: (() -> Void)? = nil,
        onPrefetch: (() -> Void)? = nil,
        swipeActions: [TableSwipeAction]? = nil,
        isSelectionEnabled: Bool = true
    ) {
        self.text = text
        super.init(onSelect: onSelect, onPrefetch: onPrefetch, swipeActions: swipeActions, isSelectable: isSelectionEnabled)
    }

    public override func configure(cell: BaseCell) {
        super.configure(cell: cell)
    }
}
