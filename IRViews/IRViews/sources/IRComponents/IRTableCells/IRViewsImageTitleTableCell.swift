//
//  IRViewsImageTitleTableCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 7.03.2025.
//

import UIKit
import SnapKit

public final class IRViewsImageTitleTableCell: IRViewsBaseTableCell {
    
    private lazy var imageViewContainer = UIImageView()
    private lazy var titleLabel = UILabel()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        imageViewContainer.contentMode = .scaleAspectFit
        imageViewContainer.layer.cornerRadius = 8
        imageViewContainer.clipsToBounds = true
        
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        contentView.addSubviews(imageViewContainer, titleLabel)
        
        imageViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageViewContainer.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    public func configure(with viewModel: IRViewsImageTitleCellViewModel) {
        imageViewContainer.image = viewModel.image
        titleLabel.text = viewModel.title
    }
}

public final class IRViewsImageTitleCellViewModel: IRViewsBaseTableCellViewModelProtocol {
    public typealias CellType = IRViewsImageTitleTableCell
    
    let title: String
    let image: UIImage?
    
    public init(title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
    
    public func configure(_ cell: IRViewsImageTitleTableCell) {
        cell.configure(with: self)
    }
}
