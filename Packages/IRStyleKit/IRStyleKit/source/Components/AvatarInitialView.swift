//
//  AvatarInitialView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import UIKit
import IRFoundation

public final class AvatarInitialView: UIView {
    
    private lazy var imageView = ImageView()
        .withSize(width: 48)
        .withCornerRadius(24)
    
    private lazy var initialsLabel = TextLabel()
        .withTypography(.title(.two))
        .withAlignment(.center)
        .withTextColor(.label)
        .withBorder(.circle, colour: .gray)
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubviews(imageView, initialsLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            initialsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        configure(hasImage: false)
    }
    
    @discardableResult
    public func withImage(_ image: UIImage?) -> Self {
        imageView.withImage(image)
        configure(hasImage: image != nil)
        return self
    }
    
    @discardableResult
    public func withNameInitials(_ initials: String) -> Self {
        initialsLabel.withText(initials)
        return self
    }
    
    private func configure(hasImage: Bool) {
        imageView.isHidden = !hasImage
        initialsLabel.isHidden = hasImage
    }
}
