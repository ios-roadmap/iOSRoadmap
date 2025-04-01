//
//  IRTableViewCell.swift
//  IRBase
//
//  Created by Ömer Faruk Öztürk on 26.03.2025.
//

import UIKit

open class IRTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        baseSetupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        baseSetupViews()
    }
    
    private func baseSetupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
    }
    
    open func setupViews() { }
    
    open func configure(with item: any IRTableViewCellViewModelProtocol) {}
}
