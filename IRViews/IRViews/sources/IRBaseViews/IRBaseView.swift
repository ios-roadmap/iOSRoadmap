//
//  IRBaseView.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 7.03.2025.
//

import UIKit

public protocol IRViewProtocol {
    func setupViews()
    func setupConstraints()
    func configure()
}

public extension IRViewProtocol {
    func configure() {}
}

open class IRBaseView: UIView, IRViewProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        configure()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setupViews() {}
    open func setupConstraints() {}
    open func configure() {}
}
