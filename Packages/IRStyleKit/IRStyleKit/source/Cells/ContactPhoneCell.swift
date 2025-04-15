//
//  ContactPhoneCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 14.04.2025.
//

import UIKit

public final class ContactPhoneCell: IRBaseCell {

    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "phone")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titlePhone, labelPhone])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titlePhone: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textColor = .label
        view.text = "Omer Faruk"
        view.textAlignment = .left
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelPhone: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textColor = .secondaryLabel
        view.text = "+90 543 123 32 32"
        view.textAlignment = .left
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ellipsisButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "ellipsis")
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, verticalStackView, ellipsisButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    public override func setup() {
        super.setup()
        
        contentView.addSubview(horizontalStackView)
        setupConstraints()
        
        ellipsisButton.addAction {
            print("Triggered ellipsis button action")
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            ellipsisButton.widthAnchor.constraint(equalToConstant: 32),
            ellipsisButton.heightAnchor.constraint(equalTo: ellipsisButton.widthAnchor)
        ])
    }

    public override func configureContent(with viewModel: IRBaseCellViewModel) {
        guard let viewModel = viewModel as? ContactPhoneCellViewModel else { return }
        
    }
}

public final class ContactPhoneCellViewModel: IRBaseCellViewModel {
    public override class var cellClass: IRBaseCell.Type { ContactPhoneCell.self }

    public override init(
        onSelect: (() -> Void)? = nil,
        onPrefetch: (() -> Void)? = nil,
        swipeActions: [IRSwipeAction]? = nil,
        isSelectionEnabled: Bool = false
    ) {
        
        super.init(onSelect: onSelect, onPrefetch: onPrefetch, swipeActions: swipeActions, isSelectionEnabled: isSelectionEnabled)
    }

    public override func configure(cell: IRBaseCell) {
        super.configure(cell: cell)
    }
}
