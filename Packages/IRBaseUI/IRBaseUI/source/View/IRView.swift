//
//  IRView.swift
//  IRBaseUI
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

import UIKit

public protocol IRViewModel { }

public class IRView<ViewModel: IRViewModel>: UIView {
    
    private var viewModel: ViewModel?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    open func setupUI() { }
    
    open func configure(viewModel: ViewModel?) {
        self.viewModel = viewModel
    }
}
