//
//  IRDependencyContainer.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//

import Foundation

/*
 TODO: IRWiki - Dependency Container
 
 Bir uygulamanın farklı bileşenleri arasında bağımlılık yönetimini sağlayan bir design patterndir.
 
 Inversion of Control (IoC) ve Dependency Injection (DI) ilkelerini esas alır.
 
 Bağımlılıkları manuel olarak değil, merkezi noktadan yönetir.
 
 Loose Coupling: Bağımlılıkları doğrudan oluşturmak yerine, dışarıdan sağlayarak sıkı bağımlılığı azaltır.
 Testability: Mock nesnelerle test yazmayı kolaylaştırır.
 Flexibility: Servislerin çalışma zamanın farklı versiyonlarını enjekte etmeye olanak tanır.
 DRY - Don't Repeat Yourself: Merkezi noktadan yapıldığı için kod tekrarını engeller.
 
 
 */

//Burada Swinject kütüphanesi örnek alınarak çalışma yapılmıştır. Olası durumda o kütüphane daha fazla incelenecektir.

@MainActor
public final class IRCoreDependencyContainer {
    public static let shared = IRCoreDependencyContainer()

    private var strongRegistry = [String: AnyObject]()
    private var weakRegistry = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)

    private init() {}

    public func register<T>(_ dependency: T, strong: Bool = false) {
        let key = String(describing: T.self)
        if strong {
            strongRegistry[key] = dependency as AnyObject
        } else {
            weakRegistry.setObject(dependency as AnyObject, forKey: key as NSString)
        }
    }

    public func resolve<T>() -> T? {
        let key = String(describing: T.self)
        return (strongRegistry[key] as? T) ?? (weakRegistry.object(forKey: key as NSString) as? T)
    }

    public func unregister<T>(_ type: T.Type) {
        let key = String(describing: type)
        strongRegistry.removeValue(forKey: key)
        weakRegistry.removeObject(forKey: key as NSString)
    }

    public func debugPrint() {
        print("🔍 Strong Registry: \(strongRegistry.keys)")
        print("🔍 Weak Registry: \(weakRegistry)")
    }
}

