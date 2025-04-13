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
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: false)
        }
    }
    
    @discardableResult
    func addSnapshot(of view: UIView, with margin: UIEdgeInsets? = nil) -> UIView? {
        guard let snapshot = view.snapshotImage,
              let globalOrigin = view.superview?.convert(view.frame.origin, to: nil) else {
            return nil
        }

        var frame = CGRect(origin: globalOrigin, size: view.frame.size)
        if let margin {
            frame = frame.inset(by: .init(
                top: -margin.top,
                left: -margin.left,
                bottom: -margin.bottom,
                right: -margin.right
            ))
        }

        let imageView = UIImageView(image: snapshot)
        imageView.frame = frame
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        imageView.layer.cornerRadius = 4
        addSubview(imageView)
        imageView.fadeIn()
        return imageView
    }
    
    func removeSnapshots() {
        subviews.compactMap { $0 as? IRSnapshotView }.forEach { snapshot in
            snapshot.fadeOut {
                snapshot.removeFromSuperview()
            }
        }
    }
}
