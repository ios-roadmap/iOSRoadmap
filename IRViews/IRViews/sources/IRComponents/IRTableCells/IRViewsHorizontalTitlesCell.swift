//
//  IRViewsHorizontalTitlesCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 12.03.2025.
//

import UIKit
import SnapKit

public final class IRViewsHorizontalTitlesCell: IRViewsBaseTableCell {
    
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
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(horizontalStackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview() // StackView'in yükseklik açısından ScrollView'e eşit olması önemli
            make.width.greaterThanOrEqualTo(scrollView) // İçerik en az ScrollView kadar geniş olmalı
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
    
    public func configure(with viewModel: IRViewsHorizontalTitlesCellViewModel) {
        horizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        viewModel.titles.forEach { title in
            let buttonView = IRViewsImageButtonView()
            horizontalStackView.addArrangedSubview(buttonView)
        }

        if let lastView = horizontalStackView.arrangedSubviews.last {
            lastView.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
            }
        }
    }
}

public final class IRViewsHorizontalTitlesCellViewModel: IRViewsBaseTableCellViewModelProtocol {
    public typealias CellType = IRViewsHorizontalTitlesCell
    
    let titles: [String]
    
    public init(titles: [String]) {
        self.titles = titles
    }
    
    public func configure(_ cell: IRViewsHorizontalTitlesCell) {
        cell.configure(with: self)
    }
}
