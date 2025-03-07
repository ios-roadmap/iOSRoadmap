//
//  IRSquareCollectionCellBuilder.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 7.03.2025.
//

import UIKit

public final class IRSquareCollectionCellBuilder {
    private var image: String?
    private var name: String?
    
    public init(image: String? = nil, name: String? = nil) {
        self.image = image
        self.name = name
    }

    public func setImage(_ image: String?) -> IRSquareCollectionCellBuilder {
        self.image = image
        return self
    }

    public func setName(_ name: String?) -> IRSquareCollectionCellBuilder {
        self.name = name
        return self
    }

    public func build() -> IRSquareCollectionCell {
        let cell = IRSquareCollectionCell()
        cell.configure(image: image, name: name)
        return cell
    }
}
