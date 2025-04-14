//
//  ContactPhoneCell.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 14.04.2025.
//

import UIKit

public final class ContactPhoneCell: IRBaseCell {

    private lazy var imagePhone: UIImageView = {
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
    
    private lazy var iconButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.init(systemName: "ellipsis.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imagePhone, verticalStackView, iconButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    public override func setup() {
        super.setup()
        
        setupViews()
    }
    
    func setupViews() {
      
        contentView.addSubview(horizontalStackView)
        
        setupConstrainsts()
    }
    
    func setupConstrainsts() {
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
