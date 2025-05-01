//
//  IndicatorView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 1.05.2025.
//

import UIKit

public final class IndicatorView: UIView {

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBlue
        layer.cornerRadius = 1
        isUserInteractionEnabled = false
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }
}
