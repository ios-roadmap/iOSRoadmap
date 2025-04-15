//
//  UIView+Snapshot.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 13.04.2025.
//

import UIKit

private final class IRSnapshotView: UIImageView { }

public extension UIView {
    
    //MARK: Snapshot Noktaları. Müsait bir zamanda denenecek
    /// - Paylaşılabilir görseller (kart, grafik, sertifika) oluşturmak için kullanılır.
    /// - Ağır view’lar yerine snapshot ile akıcı animasyonlar yapılabilir.
    /// - Yüklenmemiş içerikler için hızlı placeholder göstermek mümkündür.
    /// - UI testlerinde ekran çıktısını karşılaştırmak için snapshot alınabilir.
    /// - Özel geçiş animasyonlarında view’ın kopyası ile animasyon yapılabilir.
    /// - Uygulama arka plana giderken ekranın blur’lu hali gösterilebilir.
    /// - View hiyerarşisini `UIImage` olarak cache’leyip performans kazanabilirsin.
    var snapshotImage: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { [weak self] _ in
            guard let self else { return }
            self.drawHierarchy(in: bounds, afterScreenUpdates: false)
        }
    }
    
    @discardableResult
    func addSnapshot(of view: UIView, with margin: UIEdgeInsets? = nil) -> UIView? {
        guard let snapshot = view.snapshotImage,
              let globalPoint = view.superview?.convert(view.frame.origin, to: nil) else {
            return nil
        }

        var updatedPoint = globalPoint
        var updatedSize = view.frame.size
        
        if let margin {
            updatedPoint.x -= margin.left
            updatedPoint.y -= margin.top
            
            updatedSize.width += (margin.right + margin.left)
            updatedSize.height += (margin.top + margin.bottom)
        }
        
        let imageView = IRSnapshotView(image: snapshot)
        imageView.frame = CGRect(origin: updatedPoint, size: updatedSize)
        imageView.contentMode = .center
        imageView.backgroundColor = .yellow
        imageView.layer.cornerRadius = 6
        
        addSubviews(imageView)
        imageView.fadeIn()
        
        return imageView
    }
    
    func removeSnapshots() {
        subviews
            .lazy
            .filter { $0 is IRSnapshotView }
            .forEach { snapShowView in
                snapShowView.fadeOut {
                    snapShowView.removeFromSuperview()
                }
            }
    }
}
