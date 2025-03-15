//
//  IRViewsSpacerCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 13.03.2025.
//

import UIKit
import SnapKit

public final class IRViewsSpacerCell: IRViewsBaseTableCell {
    
    private lazy var spacerView = UIView()
    private var heightConstraint: Constraint?

    public override func setupViews() {
        contentView.addSubview(spacerView)
        spacerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            heightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    public override func configure(with item: any IRViewsBaseTableCellViewModelProtocol) {
        guard let viewModel = item as? IRViewsSpacerCellViewModel else { return }
        
        heightConstraint?.update(offset: viewModel.height)
    }
}

public final class IRViewsSpacerCellViewModel: IRViewsBaseTableCellViewModelProtocol {
    public typealias CellType = IRViewsSpacerCell
    
    let height: CGFloat
    
    public init(height: CGFloat) {
        self.height = height
    }
    
    public func configure(_ cell: IRViewsSpacerCell) {
        cell.configure(with: self)
    }
}
