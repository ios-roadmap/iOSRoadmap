//
//  InsecurePersistent.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 19.05.2025.
//

import Foundation

protocol PersistentKey: Hashable {
    associatedtype ValueType
    var id: String { get }
}

public struct InsecureKey<Value: Codable>: PersistentKey {
    public typealias ValueType = Value

    public private(set) var id: String
    public private(set) var suitName: String?
    public private(set) var defaultValue: Value?

    public init(id: String, defaultValue: Value? = nil, suitName: String? = "omerfarukozturk.com") {
        self.id = id
        self.defaultValue = defaultValue
        self.suitName = suitName
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(suitName)
    }

    public static func == (lhs: InsecureKey<Value>, rhs: InsecureKey<Value>) -> Bool {
        return lhs.id == rhs.id
    }
}

@propertyWrapper
public struct InsecurePersistent<Value: Codable> {
    let key: InsecureKey<Value>
    var storage: UserDefaults

    public var wrappedValue: Value? {
        get {
            (storage.value(forKey: key.id) as? Value) ?? key.defaultValue
        }
        set {
            if newValue.isNil {
                storage.removeObject(forKey: key.id)
            } else {
                storage.setValue(newValue, forKey: key.id)
            }
            storage.synchronize()
        }
    }

    public init(wrappedValue defaultValue: Value?, key: InsecureKey<Value>) {
        self.key = key
        if let suitName = key.suitName {
            if let userDefaults = UserDefaults(suiteName: suitName) {
                self.storage = userDefaults
            } else {
                print("The suite name \"\(suitName)\" is not appropriate, using UserDefaults.standard as backup")
                self.storage = UserDefaults.standard
            }
        } else {
            self.storage = UserDefaults.standard
        }
    }

    public init(key: InsecureKey<Value>) {
        self.init(wrappedValue: nil, key: key)
    }
}

extension Optional {
    var isNil: Bool {
        self == nil
    }
}
