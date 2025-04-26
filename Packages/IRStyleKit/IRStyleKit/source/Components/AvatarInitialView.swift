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
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        imageView
            .withImage(nil)
        
        initialsLabel
            .withText("OO")
        
        addSubviews(imageView, initialsLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            initialsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    /// Supply a UIImage. If `image == nil`, the view falls back to initials.
    @discardableResult
    public func withImage(_ image: UIImage?) -> Self {
        imageView.withImage(image)
        configure(hasImage: image != nil)
        return self
    }

    /// Supply the full name to derive initials (diacritics stripped, e.g. “Ö” → “O”).
    @discardableResult
    public func withName(_ fullName: String) -> Self {
        initialsLabel.withText(fullName.normalised.initials)
        configure(hasImage: false)
        return self
    }
}
