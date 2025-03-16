//
//  IRViewsBaseView.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 14.03.2025.
//

import UIKit

public protocol IRViewsBaseViewModel { }

public class IRViewsBaseView<ViewModel: IRViewsBaseViewModel>: UIView {
    
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
