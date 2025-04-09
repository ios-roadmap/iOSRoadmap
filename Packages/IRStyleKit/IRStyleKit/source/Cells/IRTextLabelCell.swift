//
//  IRTextLabelCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit

public final class IRTextCell: IRBaseCell {
    
    private lazy var labelView = IRTextLabelView()

    public override func setup() {
        super.setup()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelView)

        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    public override func configureContent(with viewModel: IRBaseCellViewModel) {
        guard let viewModel = viewModel as? IRTextCellViewModel else { return }
        
        labelView.configure(text: viewModel.text)
    }
}

public final class IRTextCellViewModel: IRBaseCellViewModel {
    public override class var cellClass: IRBaseCell.Type { IRTextCell.self }

    public let text: String

    public init(
        text: String,
        onSelect: (() -> Void)? = nil,
        onPrefetch: (() -> Void)? = nil,
        swipeActions: [IRSwipeAction]? = nil,
        isSelectionEnabled: Bool = true
    ) {
        self.text = text
        super.init(onSelect: onSelect, onPrefetch: onPrefetch, swipeActions: swipeActions, isSelectionEnabled: isSelectionEnabled)
    }

    public override func configure(cell: IRBaseCell) {
        super.configure(cell: cell)
    }
}
