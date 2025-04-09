//
//  IRSpacerCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 26.03.2025.
//

import UIKit

public final class IRSpacerCell: IRBaseCell {

    private let spacerView = IRSpacerView()

    public override func setup() {
        super.setup()
        contentView.addSubview(spacerView)
        spacerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spacerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            spacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    public override func configureContent(with viewModel: IRBaseCellViewModel) {
        guard let viewModel = viewModel as? IRSpacerCellViewModel else { return }
        spacerView.configure(height: viewModel.height, backgroundColor: viewModel.backgroundColor)
    }
}

public final class IRSpacerCellViewModel: IRBaseCellViewModel {
    public override class var cellClass: IRBaseCell.Type { IRSpacerCell.self }

    public let height: CGFloat
    public let backgroundColor: UIColor?

    public init(
        height: CGFloat,
        backgroundColor: UIColor? = nil,
        onSelect: (() -> Void)? = nil,
        onPrefetch: (() -> Void)? = nil,
        swipeActions: [IRSwipeAction]? = nil,
        isSelectionEnabled: Bool = false
    ) {
        self.height = height
        self.backgroundColor = backgroundColor
        super.init(onSelect: onSelect, onPrefetch: onPrefetch, swipeActions: swipeActions, isSelectionEnabled: isSelectionEnabled)
    }

    public override func configure(cell: IRBaseCell) {
        super.configure(cell: cell)
    }
}
