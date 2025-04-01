//
//  IRSpacerCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 26.03.2025.
//

import UIKit
import IRBase

public final class IRSpacerCell: IRTableViewCell {

    private let spacerView = UIView()
    private var heightConstraint: NSLayoutConstraint?

    public override func setupViews() {
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spacerView)

        NSLayoutConstraint.activate([
            spacerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            spacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        let height = spacerView.heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
        heightConstraint = height
    }

    public override func configure(with item: any IRTableViewCellViewModelProtocol) {
        guard let viewModel = item as? IRSpacerCellViewModel else { return }
        heightConstraint?.constant = viewModel.height
        spacerView.backgroundColor = viewModel.backgroundColor
    }
}

public final class IRSpacerCellViewModel: IRTableViewCellViewModelProtocol {
    public typealias CellType = IRSpacerCell

    let height: CGFloat
    let backgroundColor: UIColor?

    public init(height: CGFloat, backgroundColor: UIColor? = nil) {
        self.height = height
        self.backgroundColor = backgroundColor
    }

    public func configure(_ cell: IRSpacerCell) {
        cell.configure(with: self)
    }
}
