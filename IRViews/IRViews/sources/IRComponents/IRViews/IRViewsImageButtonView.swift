//
//  IRViewsImageButtonView.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 12.03.2025.
//

import UIKit
import SnapKit

public final class IRViewsImageButtonView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .green
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubviews(imageView, titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let height = 120 + 8 + titleLabel.intrinsicContentSize.height
        let width = max(120, titleLabel.intrinsicContentSize.width)
        return CGSize(width: width, height: height)
    }
}
