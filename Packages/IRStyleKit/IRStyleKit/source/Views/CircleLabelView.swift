//
//  CircleLabelView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 27.08.2025.
//

import UIKit

public final class CircleLabelViewModel {
    public let text: String
    public let textColor: UIColor
    public let font: UIFont
    public let circleColor: UIColor
    
    public init(
        text: String,
        textColor: UIColor = .white,
        font: UIFont = .boldSystemFont(ofSize: 18),
        circleColor: UIColor = .systemRed
    ) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.circleColor = circleColor
    }
}

public final class CircleLabelView: UIView {
    
    private let label = UILabel()
    private var viewModel: CircleLabelViewModel
    
    // MARK: - Init
    public init(viewModel: CircleLabelViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
        applyViewModel()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func applyViewModel() {
        label.text = viewModel.text
        label.textColor = viewModel.textColor
        label.font = viewModel.font
        backgroundColor = viewModel.circleColor
    }
    
    // MARK: - Update
    public func update(viewModel: CircleLabelViewModel) {
        self.viewModel = viewModel
        applyViewModel()
        setNeedsLayout()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
}
