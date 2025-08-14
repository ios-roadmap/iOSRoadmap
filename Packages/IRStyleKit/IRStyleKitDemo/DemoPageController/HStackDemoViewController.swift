//
//  HStackDemoViewController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 14.08.2025.
//

import UIKit
import IRStyleKit

// 1) Sola hizalayan flow layout
final class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .vertical
        minimumInteritemSpacing = 8
        minimumLineSpacing = 8
        sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        sectionInsetReference = .fromSafeArea
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Apple’ın özniteliklerini kopyala (mutation-safe)
        guard let attrs = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() as! UICollectionViewLayoutAttributes }) else {
            return nil
        }
        // Satır satır sola hizala
        var left = sectionInset.left
        var currentRowY: CGFloat = -CGFloat.greatestFiniteMagnitude
        let rowThreshold: CGFloat = 1.0 // satır değişimini algılamak için tolerans
        
        for a in attrs where a.representedElementCategory == .cell {
            // Yeni satır mı?
            if abs(a.frame.origin.y - currentRowY) > rowThreshold {
                currentRowY = a.frame.origin.y
                left = sectionInset.left
            }
            var f = a.frame
            f.origin.x = left
            a.frame = f
            left = f.maxX + minimumInteritemSpacing
        }
        return attrs
    }
    
    // Self-sizing sonrası atlamaları azaltmak için
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
                                         withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        true
    }
}

// 2) İçerik view (örnek)
final class TagView: UIView {
    private let label = UILabel()
    
    init(text: String) {
        super.init(frame: .zero)
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        directionalLayoutMargins = .init(top: 6, leading: 10, bottom: 6, trailing: 10)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        
        // Self-sizing için önemli: genişlikte kırpılmayı engelle
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .horizontal)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// 3) Hücre
final class TagCell: UICollectionViewCell {
    static let reuseID = "TagCell"
    private var hostedView: UIView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostedView?.removeFromSuperview()
        hostedView = nil
    }
    
    func configure(with view: UIView) {
        hostedView?.removeFromSuperview()
        hostedView = view
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        // İçeriğin boyut hesaplamasını doğru yapması için:
        contentView.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.setContentHuggingPriority(.required, for: .horizontal)
    }
}

// 4) VC
final class HStackDemoViewController: IRViewController, ShowcaseListViewControllerProtocol, UICollectionViewDataSource {
    private let items = [
        "UIKit","Auto Layout","UICollectionView","FlowLayout","Self-Sizing",
        "LongText-Örnek-1234567890","Tag","iOS","Swift","CustomView","Wrap","Satır Kırma"
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.dataSource = self
        cv.alwaysBounceVertical = true
        cv.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseID)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wrapping Views"
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { items.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseID, for: indexPath) as! TagCell
        cell.configure(with: TagView(text: items[indexPath.item]))
        return cell
    }
}
