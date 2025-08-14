//
//  UITextFieldDelegateEvent.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 3.07.2025.
//


import UIKit

public protocol TextFieldInterceptor: AnyObject, UITextFieldDelegate {}

final class PhoneMaskedInputFieldDelegate: NSObject, TextFieldInterceptor {
    //Assume this place is full
}

final class CreditCardMaskedInputFieldDelegate: NSObject, TextFieldInterceptor {
    //Assume this place is full
}

final class PasswordMaskedInputFieldDelegate: NSObject, TextFieldInterceptor {
    //Assume this place is full
}

final class IBANMaskedInputFieldDelegate: NSObject, TextFieldInterceptor {
    //Assume this place is full
}

private struct WeakInterceptor {
    weak var value: (any TextFieldInterceptor)?
}

// MARK: - Composite delegate
public final class UITextFieldCompositeDelegate: NSObject, UITextFieldDelegate {
    
    // Weak wrapper so interceptors don’t create retain cycles
    
    private var interceptors: [WeakInterceptor] = []
    weak var primary: UITextFieldDelegate?
    
    // MARK: attach / detach
    func add(_ interceptor: some TextFieldInterceptor) {
        interceptors.append(.init(value: interceptor))
    }
    
    func remove(_ interceptor: some TextFieldInterceptor) {
        interceptors.removeAll { $0.value === interceptor || $0.value == nil }
    }
    
    var isEmpty: Bool { interceptors.allSatisfy { $0.value == nil } }
    
    // MARK: UITextFieldDelegate calls you care about
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        interceptors.forEach { $0.value?.textFieldDidChangeSelection?(textField) }
        primary?.textFieldDidChangeSelection?(textField)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        interceptors.forEach { $0.value?.textFieldDidBeginEditing?(textField) }
        primary?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        interceptors.forEach { $0.value?.textFieldDidEndEditing?(textField) }
        primary?.textFieldDidEndEditing?(textField)
    }
    
    // MARK: message forwarding
    public override func responds(to sel: Selector!) -> Bool {
        super.responds(to: sel)
        || primary?.responds(to: sel) == true
        || interceptors.contains { $0.value?.responds(to: sel) == true }
    }
    
    public override func forwardingTarget(for sel: Selector!) -> Any? {
        primary?.responds(to: sel) == true ? primary : nil
    }
}

// MARK: - UITextField helpers
public extension UITextField {
    
    private enum Keys { static var composite = 0 }
    
    /// Lazily create / return the single composite delegate.
    private var composite: UITextFieldCompositeDelegate {
        if let c = objc_getAssociatedObject(self, &Keys.composite)
            as? UITextFieldCompositeDelegate { return c }
        
        let c = UITextFieldCompositeDelegate()
        c.primary = delegate                 // preserve any existing delegate
        delegate = c                         // install once
        objc_setAssociatedObject(self, &Keys.composite,
                                 c, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return c
    }
    
    /// Add an interceptor.
    func attach(_ interceptor: TextFieldInterceptor) {
        composite.add(interceptor)
    }
    
    /// Remove an interceptor.
    func detach(_ interceptor: TextFieldInterceptor) {
        composite.remove(interceptor)
        // If no interceptors left, restore the original delegate.
        if composite.isEmpty {
            delegate = composite.primary
            objc_setAssociatedObject(self, &Keys.composite, nil,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

