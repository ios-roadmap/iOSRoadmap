//
//  IRAssetsImages.swift
//  IRAssets
//
//  Created by Ömer Faruk Öztürk on 14.03.2025.
//

//TODO: Bu modül için R swift ya da SwiftGen tarzı bir kütüphane ile yönetilecek.

import UIKit

public protocol IRAssetsRawRepresentable: RawRepresentable where RawValue == String { }

public extension IRAssetsRawRepresentable {
    var image: UIImage {
        //Eğer farklı modülden bakarsak .module'u görüyor.
        UIImage(named: rawValue, in: .module, compatibleWith: nil) ?? UIImage(systemName: "exclamationmark.triangle")!
    }
    
    var formatted: String {
        rawValue
            .replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
            .capitalized
    }
}

public enum IRAssets {
    public enum Main: String, IRAssetsRawRepresentable {
        case iOSRoadmap
    }
    
    public enum Dashboard: String, IRAssetsRawRepresentable {
        case rickAndMorty
        case jsonPlaceHolder
    }
}

/*
 
 🚀 Enum vs. Class Karşılaştırması (IRAssetsImages için)
 🔹 1️⃣ Bellek Kullanımı:

 Enum → Compile-time hesaplanır, ekstra bellek tüketmez. (Daha avantajlı ✅)
 Class → Heap’te yer kaplar, singleton bile olsa bir miktar bellek kullanır.
 🔹 2️⃣ Erişim Hızı:

 Enum → Statik olarak tanımlandığı için doğrudan çağrılır. (O(1) erişim süresi)
 Class → Singleton olsa bile ilk çağrıda init edilmesi gerekir.
 🔹 3️⃣ Thread-Safety:

 Enum → Immutable ve %100 thread-safe.
 Class → Singleton olsa bile paylaşılan state varsa thread-safe olmayabilir.
 🔹 4️⃣ Lazy-Loading (Geç Yükleme):

 Enum → Tüm değerler anında belleğe yüklenir.
 Class → Singleton olursa sadece ilk erişimde yüklenir. (Avantajlı olabilir)
 🔹 5️⃣ Genişletilebilirlik:

 Enum → Yeni değer eklemek için enum’u değiştirmek gerekir.
 Class → Alt sınıflarla veya dependency injection ile genişletilebilir.
 🔹 6️⃣ Kullanım Senaryoları:

 Statik asset listesi → Enum kullan ✅
 Dinamik yüklenen assetler (örneğin uzaktan çekilen görseller) → Class kullan ✅
 Hafıza optimizasyonu ve genişletilebilirlik önemliyse → Class kullan ✅
 🎯 Özet Sonuç:
 Statik asset’ler için enum en hızlı ve verimli çözüm! 🚀
 Lazy-loading ve dinamik yapı gerekiyorsa class avantajlı olabilir.
 
 */
