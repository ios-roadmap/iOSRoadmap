//
//  IRBaseCollectionViewCell.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 7.03.2025.
//

import UIKit
import IRCommon

public protocol IRBaseViewCellProtocol: AnyObject {
    static var identifier: String { get }
    func setupViews()
    func setupConstraints()
}

extension IRBaseViewCellProtocol {
    public static var identifier: String { String(describing: Self.self) }
}

//MARK: Base Collection View Cell
open class IRBaseCollectionViewCell: UICollectionViewCell, IRBaseViewCellProtocol {
    open func setupViews() {}
    open func setupConstraints() {}

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required public init?(coder: NSCoder) { fatalError() }
}

//MARK: Base Table View Cell
open class IRBaseTableViewCell: UITableViewCell, IRBaseViewCellProtocol {
    open func setupViews() {}
    open func setupConstraints() {}

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required public init?(coder: NSCoder) { fatalError() }
}

//MARK: ConfigurableCell Protocol & Model

public struct IRConfigurableViewSection<DataType> {
    public var header: String?
    public var items: [DataType]
    
    public init(header: String? = nil, items: [DataType] = []) {
        self.header = header
        self.items = items
    }
}

public protocol IRConfigurableCellProtocol: IRBaseViewCellProtocol {
    associatedtype DataType
    func configure(with data: DataType)

    static var cellClass: UICollectionViewCell.Type { get }
}

extension IRConfigurableCellProtocol where Self: UICollectionViewCell {
    static var cellClass: UICollectionViewCell.Type {
        return Self.self
    }
}

extension IRConfigurableCellProtocol where Self: UITableViewCell {
    func configure(with data: UITableViewCell) {
       
    }
}

extension IRConfigurableCellProtocol where Self: UICollectionViewCell {
    func configure(with data: UICollectionViewCell) {
        
    }
}

extension UICollectionView {
    public func dequeueReusableCell<T: IRBaseViewCellProtocol>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}

extension UITableView {
    public func dequeueReusableCell<T: IRBaseViewCellProtocol>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}
