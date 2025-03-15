//
//  IRAssetsImages.swift
//  IRAssets
//
//  Created by Ömer Faruk Öztürk on 14.03.2025.
//

//TODO: Bu modül için R swift ya da SwiftGen tarzı bir kütüphane ile yönetilecek.

import UIKit

public enum IRAssetsImages {
    public enum Main {
        public static let appIcon = UIImage(named: "IRMedia/AppIcon", in: IRAssets.bundle, compatibleWith: nil)
    }
    
    public enum Dashboard {
        public static let rickAndMorty = UIImage(named: "IRMedia/RickAndMorty", in: .main, compatibleWith: nil)
        public static let jsonPlaceHolder = UIImage(named: "IRMedia/JsonPlaceHolder", in: .main, compatibleWith: nil)
    }
}
