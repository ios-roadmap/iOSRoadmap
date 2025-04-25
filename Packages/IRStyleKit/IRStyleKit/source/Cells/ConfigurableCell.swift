//
//  ConfigurableCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 25.04.2025.
//

import UIKit

public final class ConfigurableCell: IRBaseCell {
    
    private lazy var profilImage = ImageView()
        .withContentMode(.scaleAspectFit)
        .withSize(width: 48)
        .withContentHugging(.required, axis: .horizontal)
        .withCompressionResistance(.required, axis: .horizontal)
    
    //TODO: BOLD'luk vs. değişebilmeli nested enum
    private lazy var primaryLabel = TextLabel()
        .withTypography(.body(.semibold))
    
    private lazy var secondaryLabel = TextLabel()
        .withTypography(.caption(.two))
    
    private lazy var labelStack = StackView(.vertical()) {
        primaryLabel
        secondaryLabel
    }
    
    private lazy var contentStack = StackView(.horizontal()) {
        profilImage
        labelStack
    }
    
    public override func setup() {
        super.setup()
        
        contentView.addSubview(contentStack)
        appLayout()
    }
    
    func appLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    public override func configureContent(with viewModel: IRBaseCellViewModel) {
        guard let viewModel = viewModel as? ConfigurableCellViewModel else { return }
        
        profilImage.withImage(.add)
        primaryLabel.withText("OMER")
        secondaryLabel.withText("@ING")
    }
}

public final class ConfigurableCellViewModel: IRBaseCellViewModel {
    
    public override class var cellClass: IRBaseCell.Type { ConfigurableCell.self }
    
    public init() {
        
        super.init()
    }
}
