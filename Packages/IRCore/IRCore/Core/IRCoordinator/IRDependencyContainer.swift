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
public final class IRDependencyContainer {
    
    public enum IRContainerScope {
        case module
        case service
    }
    
    private var registry: [IRContainerScope: [String: () -> Any]] = [
        .module: [:],
        .service: [:]
    ]
    
    public static let shared = IRDependencyContainer()
    
    //Burada instance’ı değil, onu oluşturacak closure’ı tutuyorsun. Nesne henüz oluşturulmaz, sadece nasıl oluşturulacağı saklanır. resolve() çağrıldığında nesne o an yaratılır.
    private var factoryRegistry = [String: () -> Any]()
    /// 🤯 Ama neden? Şöyle yapsaydık olmaz mıydı?
    /// private var factoryRegistry = [String: Any]()
    /// Ve sonra:
    /// register(IRJPHInterface.self, factory: IRJPHFactory().create())
    ///
    /// Evet olurdu ama bu durumda:
    /// Tüm bağımlılıklar uygulama başlarken oluşturulur. Lifecycle kontrolü, performans ve testability kaybolur. Injection sırasında henüz ihtiyaç duyulmayan nesneler de yaratılmış olur. ❌ Özellikle view controller'lar gibi "heavy" objeleri eager olarak yaratmak istemezsin.
    
    private init() {}
    
    public func register<T>(_ type: T.Type, scope: IRContainerScope, factory: @escaping () -> T) {
        let key = String(describing: type)
        registry[scope]?[key] = factory
    }

    public func resolve<T>(_ scope: IRContainerScope) -> T {
        let key = String(describing: T.self)
        guard let factory = registry[scope]?[key]?() as? T else {
            fatalError("Dependency \(key) not registered in \(scope)")
        }
        return factory
    }
    
    public func unregister<T>(_ type: T.Type) {
        let key = String(describing: type)
        factoryRegistry.removeValue(forKey: key)
    }
}
