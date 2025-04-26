//
//  ContactPhoneCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 14.04.2025.
//

import UIKit

public final class ContactPhoneCell: IRBaseCell {
    
    // MARK: Layout Metrics
    private enum Metrics {
        //        static let horizontalPadding: CGFloat = 16
        //        static let verticalPadding: CGFloat   = 12
        //        static let avatarSide: CGFloat        = 48
        //        static let actionSide: CGFloat        = 32
        static let horizontalSpacing: CGFloat = 8
        static let verticalSpacing: CGFloat   = 4
    }
    
    // MARK: UI Elements
   
    
    private let nameLabel = TextLabel()
        .withTypography(.body(.semibold))
        .withTextColor(.label)
        .withAlignment(.left)
        .withLines(0)
    
    private let phoneLabel = TextLabel()
        .withTypography(.caption(.one))
        .withTextColor(.secondaryLabel)
        .withAlignment(.left)
        .withLines(0)
    
    private lazy var contentStack: StackView = {
        let vertical = StackView(.vertical(spacing: Metrics.verticalSpacing)) {
            nameLabel
            phoneLabel
        }
        
        return StackView(.horizontal(spacing: Metrics.horizontalSpacing)) {
//            avatarImageView
            vertical
        }
    }()
    
    // MARK: Lifecycle
    public override func setup() {
        super.setup()
        contentView.addSubview(contentStack)
        applyLayout()
    }
    
    // MARK: Configuration
    public override func configureContent(with viewModel: IRBaseCellViewModel) {
        guard let vm = viewModel as? ContactPhoneCellViewModel else { return }
        nameLabel.withText(vm.name)
        phoneLabel.withText(vm.maskedPhone)
//        avatarImageView.withi (vm.avatar)
    }
    
    // MARK: Private Helpers
    private func applyLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    private func handleAction() {
        print("Triggered ellipsis button action")
        // Hook to delegate / closure if required
    }
}

public final class ContactPhoneCellViewModel: IRBaseCellViewModel {
    
    let name: String
    let maskedPhone: String
    let avatar: UIImage
    
    public override class var cellClass: IRBaseCell.Type { ContactPhoneCell.self }
    
    public init(
        name: String = "ÖMER",
        phone: String = "5436176299",
        avatar: UIImage = UIImage(systemName: "person.fill")!, //TODO: Add Circle background image person.fill
        onSelect: (() -> Void)? = nil,
        onPrefetch: (() -> Void)? = nil,
        swipeActions: [IRSwipeAction]? = nil,
        isSelectionEnabled: Bool = false
    ) {
        self.name        = name
        self.maskedPhone = phone
        self.avatar      = avatar
        super.init(onSelect: onSelect,
                   onPrefetch: onPrefetch,
                   swipeActions: swipeActions,
                   isSelectionEnabled: isSelectionEnabled)
    }
}
