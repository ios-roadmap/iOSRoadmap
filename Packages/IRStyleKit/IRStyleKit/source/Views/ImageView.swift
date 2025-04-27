//
//  ImageView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 23.04.2025.
//

import UIKit

public final class ImageView: UIImageView {

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
    }
}

extension ImageView {
    
    @discardableResult
    public func withImage(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    @discardableResult
    public func withContentMode(_ mode: ContentMode) -> Self {
        self.contentMode = mode
        return self
    }

    @discardableResult
    public func withCornerRadius(_ radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        return self
    }

    @discardableResult
    public func withBackgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    @discardableResult
    public func withTintColor(_ color: UIColor?) -> Self {
        self.tintColor = color
        return self
    }

    @discardableResult
    public func withBorder(width: CGFloat, color: UIColor?) -> Self {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
        return self
    }

    @discardableResult
    public func withUserInteraction(_ enabled: Bool) -> Self {
        self.isUserInteractionEnabled = enabled
        return self
    }

    @discardableResult
    public func withAccessibilityIdentifier(_ identifier: String) -> Self {
        self.accessibilityIdentifier = identifier
        return self
    }
}

