//
//  IRViewsImageButtonView.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 12.03.2025.
//

import IRAssets
import IRCommon
import UIKit
import SnapKit

public struct IRViewsImageButtonViewModel: IRViewsBaseViewModel {
    let image: UIImage?
    let title: String?
    let handler: IRVoidHandler?
    
    public init(image: UIImage? = nil, title: String? = nil, handler: IRVoidHandler? = nil) {
        self.image = image
        self.title = title
        self.handler = handler
    }
}

public final class IRViewsImageButtonView: IRViewsBaseView<IRViewsImageButtonViewModel> {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private var handler: IRVoidHandler?
    
    public override func setupUI() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func didTapView() {
        handler?()
    }
    
    public override func configure(viewModel: IRViewsImageButtonViewModel?) {
        super.configure(viewModel: viewModel)
        imageView.image = viewModel?.image
        titleLabel.text = viewModel?.title
        handler = viewModel?.handler
    }
    
    public override var intrinsicContentSize: CGSize {
        let height = 120 + 8 + titleLabel.intrinsicContentSize.height
        let width = max(120, titleLabel.intrinsicContentSize.width)
        return CGSize(width: width, height: height)
    }
}

@MainActor
public final class IRViewsImageButtonViewBuilder {
    private var image: UIImage?
    private var title: String?
    private var handler: IRVoidHandler?
    
    public func setImage(_ image: UIImage) -> IRViewsImageButtonViewBuilder {
        self.image = image
        return self
    }
    
    public func setTitle(_ title: String) -> IRViewsImageButtonViewBuilder {
        self.title = title
        return self
    }
    
    public func build() -> IRViewsImageButtonView {
        let view = IRViewsImageButtonView()
        let viewModel = IRViewsImageButtonViewModel(
            image: image,
            title: title,
            handler: handler
        )
        view.configure(viewModel: viewModel)
        return view
    }
}
