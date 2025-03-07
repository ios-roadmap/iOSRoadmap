//
//  IRHorizontalCollectionTableCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 7.03.2025.
//

import UIKit
import IRCommon

public final class IRHorizontalCollectionTableCell: IRBaseTableViewCell {

    private lazy var collectionVC = IRBaseCollectionView()
    
    public override func setupViews() {
        super.setupViews()
        
        collectionVC.scrollDirection = .horizontal
        contentView.addSubview(collectionVC.view)
    }
    
    public override func setupConstraints() {
        collectionVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionVC.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            collectionVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            collectionVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            collectionVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            collectionVC.view.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    public func configure(with items: [IRCollectionViewItemProtocol]) {
        collectionVC.sections = [
            IRCollectionViewSection(header: nil, items: items)
        ]
    }
}
