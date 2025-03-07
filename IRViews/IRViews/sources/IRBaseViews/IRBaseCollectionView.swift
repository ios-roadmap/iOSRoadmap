//
//  IRBaseCollectionView.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 7.03.2025.
//

import UIKit
import IRCommon

public class IRBaseCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var scrollDirection: UICollectionView.ScrollDirection = .vertical {
        didSet {
            (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = scrollDirection
        }
    }
    
    var sections: [IRConfigurableViewSection<Any>] = [] {
        didSet {
            registerCells()
            collectionView.reloadData()
        }
    }
    
    var registeredCellTypes: Set<String> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func registerCells() {
        //TODO: Later
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let item = sections[indexPath.section].items[indexPath.item] as? (any IRConfigurableCellProtocol) else {
//            fatalError("Item does not conform to IRCellItemProtocol")
//        }
//
//        item.
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
//
//        // Hücreyi yapılandır
//        if let configurableCell = cell as? (any IRConfigurableCellProtocol) {
//            configurableCell.configure(with: item)
//        } else {
//            fatalError("Dequeued cell does not conform to IRConfigurableCellProtocol")
//        }
//
//        return cell
//    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemType = type(of: sections[indexPath.section].items[indexPath.item]) as? any IRConfigurableCellProtocol.Type else {
            fatalError("Item does not conform to IRConfigurableCellProtocol")
        }

        let cellType = itemType.cellClass
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath)
        
        if let configurableCell = cell as? (any IRConfigurableCellProtocol) {
            configurableCell.configure(with: item)
        } else {
            fatalError("Dequeued cell does not conform to IRConfigurableCellProtocol")
        }

        return cell
    }


    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 100)
    }
}
