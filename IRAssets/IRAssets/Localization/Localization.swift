//
//  Localization.swift
//  IRAssets
//
//  Created by Ömer Faruk Öztürk on 15.03.2025.
//

import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
