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
    let assetsImage: (any IRAssetsRawRepresentable)?
    let assetsTitle: (any IRAssetsRawRepresentable)?
    let handler: IRVoidHandler?
    
    public init(assetsImage: (any IRAssetsRawRepresentable)? = nil, assetsTitle: (any IRAssetsRawRepresentable)? = nil, handler: IRVoidHandler? = nil) {
        self.assetsImage = assetsImage
        self.assetsTitle = assetsTitle
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
        addSubviews(imageView, titleLabel)
        
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
        imageView.image = viewModel?.assetsImage?.image
        titleLabel.text = viewModel?.assetsTitle?.formatted
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
    private var assetsImage: (any IRAssetsRawRepresentable)?
    private var assetsTitle: (any IRAssetsRawRepresentable)?
    private var handler: IRVoidHandler?
    
    public func setImage(_ assetsImage: some IRAssetsRawRepresentable) -> IRViewsImageButtonViewBuilder {
        self.assetsImage = assetsImage
        return self
    }
    
    public func setTitle(_ assetsTitle: some IRAssetsRawRepresentable) -> IRViewsImageButtonViewBuilder {
        self.assetsTitle = assetsTitle
        return self
    }
    
    public func build() -> IRViewsImageButtonView {
        let view = IRViewsImageButtonView()
        let viewModel = IRViewsImageButtonViewModel(
            assetsImage: assetsImage,
            assetsTitle: assetsTitle,
            handler: handler
        )
        view.configure(viewModel: viewModel)
        return view
    }
}

/*
 Swift’te any ve some kullanımı, protokolleri nasıl ele aldığımızla ilgilidir. Bu iki kavram, varlık türleri (existential types) ve belirsiz türler (opaque types) olarak ayrılır.
 
 any, farklı türleri saklayabilmek için kullanılır. Yani:
 var image1: any IRAssetsImagesProtocol = IRAssetsImages.Main.appIcon
 var image2: any IRAssetsImagesProtocol = IRAssetsImages.Dashboard.rickAndMorty

 Bu mümkün çünkü any, farklı türlerin bir arada saklanmasına izin verir.
 
 Ancak, derleyici değişkenin hangi tür olduğunu önceden bilemez. Swift, bu türleri çalıştırma zamanında çözer (dynamic dispatch), bu da küçük bir performans kaybına neden olabilir.
 Ayrıca, any kullanıldığında, protokolün içindeki özelliklere doğrudan erişemezsin. Örneğin, aşağıdaki kod hata verir:
 let image: any IRAssetsImagesProtocol = IRAssetsImages.Main.appIcon
 print(image.image) // ❌ Hata! image özelliği çağrılamaz.
 Çünkü any, tam türü bilmediği için doğrudan bu özelliğe erişemez.
 
 Bu, setImage(_:) fonksiyonunun tek bir belirli tür kabul ettiğini ve geri kalan her şeyin derleyici tarafından belirleneceğini ifade eder.

 some, aynı anda yalnızca tek bir türü kabul eder. Örneğin:
 let image1: some IRAssetsImagesProtocol = IRAssetsImages.Main.appIcon // ✅ Geçerli
 let image2: some IRAssetsImagesProtocol = IRAssetsImages.Dashboard.rickAndMorty // ✅ Geçerli
 Ama:

 let images: [some IRAssetsImagesProtocol] = [IRAssetsImages.Main.appIcon, IRAssetsImages.Dashboard.rickAndMorty] // ❌ Hata!
 Çünkü some, farklı türleri tek bir değişkende saklamaya izin vermez.
 
 some kullanıldığında, Swift o değişkenin türünü derleme anında bilir ve bu sayede doğrudan özelliklere erişebilirsin:
 let image: some IRAssetsImagesProtocol = IRAssetsImages.Main.appIcon
 print(image.image) // ✅ Çalışır!
 
 Çünkü some, çağrıldığı yerde türü kesin olarak belirlediği için dinamik değil, statik olarak bağlanır (static dispatch). Bu da daha hızlıdır.
 
*/
