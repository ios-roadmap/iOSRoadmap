//
//  IRViewsImageButtonViewsCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 12.03.2025.
//

import UIKit
import SnapKit

public final class IRViewsImageButtonViewsCell: IRViewsBaseTableCell {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually // Değiştirildi
        return stackView
    }()

    
    public override func setupViews() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(horizontalStackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.greaterThanOrEqualTo(scrollView)
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        guard let firstButton = horizontalStackView.arrangedSubviews.first as? IRViewsImageButtonView else {
            return CGSize(width: UIView.noIntrinsicMetric, height: 70)
        }
        
        let buttonHeight = firstButton.intrinsicContentSize.height
        let totalHeight = buttonHeight + 16
        
        return CGSize(width: UIView.noIntrinsicMetric, height: max(totalHeight, 70))
    }
    
    public override func configure(with item: any IRViewsBaseTableCellViewModelProtocol) {
        guard let viewModel = item as? IRViewsImageButtonViewsCellViewModel else { return }
        
        horizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        viewModel.items.forEach { model in
            let buttonView = IRViewsImageButtonView()
            buttonView.configure(viewModel: model)
            horizontalStackView.addArrangedSubview(buttonView)
        }
        
        if let lastView = horizontalStackView.arrangedSubviews.last {
            lastView.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
            }
        }
    }
}

public final class IRViewsImageButtonViewsCellViewModel: IRViewsBaseTableCellViewModelProtocol {
    public typealias CellType = IRViewsImageButtonViewsCell
    
    let items: [IRViewsImageButtonViewModel]
    
    public init(items: [IRViewsImageButtonViewModel]) {
        self.items = items
    }
    
    public func configure(_ cell: IRViewsImageButtonViewsCell) {
        cell.configure(with: self)
    }
}
