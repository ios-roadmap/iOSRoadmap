//
//  IRAssetsRawRepresentable.swift
//  IRAssets
//
//  Created by Ömer Faruk Öztürk on 26.03.2025.
//

public protocol IRAssetsRawRepresentable: RawRepresentable where RawValue == String {}

public extension IRAssetsRawRepresentable {
    var name: String { rawValue }
}
