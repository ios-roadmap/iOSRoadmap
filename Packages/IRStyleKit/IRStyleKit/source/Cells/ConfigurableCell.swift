//
//  ConfigurableCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 25.04.2025.
//

import UIKit
import IRFoundation

public final class ConfigurableCell: BaseCell {
    
    private let avatarImageView = AvatarInitialView()
        .withContentHugging(.required, axis: .horizontal)
        .withCompressionResistance(.required, axis: .horizontal)
    
    private lazy var primaryLabel = TextLabel()
        .withTypography(.body(.semibold))
    
    private lazy var secondaryLabel = TextLabel()
        .withTypography(.body(.regular))
    
    // Label stack ─ vertical, 4-pt default spacing
    private lazy var labelStack = StackView {
        primaryLabel
        secondaryLabel
    }
    .axis(.vertical)
    .spacing(4)               // matches previous Kind.default

    // Content stack ─ horizontal, 8-pt default spacing
    private lazy var contentStack = StackView {
        avatarImageView
        labelStack
    }
    .axis(.horizontal)
    .spacing(8)
    .alignment(.center)       // keep avatar + labels nicely centred

    
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
    
    public override func configureContent(with viewModel: BaseCellViewModel) {
        guard let viewModel = viewModel as? ConfigurableCellViewModel else { return }
        
        
        primaryLabel.withText(viewModel.name)
        secondaryLabel.withText(viewModel.company)
        avatarImageView
            .withImage(nil)
            .withNameInitials(viewModel.name.normalised.initials)
    }
}

public final class ConfigurableCellViewModel: BaseCellViewModel {

    public override class var cellClass: BaseCell.Type { ConfigurableCell.self }

    let name: String
    let company: String

    public init(
        name: String,
        company: String,
        onSelect: VoidHandler? = nil,
        onPrefetch: VoidHandler? = nil,
        swipeActions: [TableSwipeAction]? = nil,
        isSelectable: Bool = true
    ) {
        self.name    = name
        self.company = company
        super.init(
            onSelect:     onSelect,
            onPrefetch:   onPrefetch,
            swipeActions: swipeActions,
            isSelectable: isSelectable
        )
    }
}
