////
////  Keys.swift
////  IRStyleKit
////
////  Created by Ömer Faruk Öztürk on 14.07.2025.
////
//
//
//import UIKit
//import ObjectiveC
//
//
//public extension UITextField {
//    private struct Keys {
//        static var proxy = 0
//        static var clear = 1
//    }
//
//    /// Returns the current (outermost) mask-delegate proxy, if any
//    var currentMaskedProxy: CRTextFieldDelegateProxy? {
//        objc_getAssociatedObject(self, &Keys.proxy) as? CRTextFieldDelegateProxy
//    }
//
//    /// Attaches a new mask-delegate proxy, wrapping the existing delegate.
//    /// - Parameters:
//    ///   - interceptor: The CRMaskedInputFieldDelegate & UITextFieldDelegate to intercept text changes
//    ///   - didChangeMaskState: Closure notifying about mask completion state changes
//    /// - Returns: The proxy that was just installed
//    @discardableResult
//    func attachMaskedDelegate(
//        interceptor: CRMaskedInputFieldDelegate?,
//        didChangeMaskState: CRGenericClosure<CRMaskModels.MaskCompletionState>? = nil
//    ) -> CRTextFieldDelegateProxy? {
//        interceptor?.didChangeMaskState = didChangeMaskState
//        let newProxy = CRTextFieldDelegateProxy(interceptor: interceptor, primary: delegate)
//        text = interceptor?.initialText
//        delegate = newProxy
//
//        objc_setAssociatedObject(self, &Keys.proxy, newProxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        interceptor?.handleMaskCompletionState(didChangeMaskState)
//        return newProxy
//    }
//
//    /// Detaches only the topmost proxy and restores the next delegate in the chain.
//    func detachMaskedDelegate() {
//        guard let top = currentMaskedProxy else { return }
//        let underneath = top.primary
//        delegate = underneath
//
//        if let nextProxy = underneath as? CRTextFieldDelegateProxy {
//            objc_setAssociatedObject(self, &Keys.proxy, nextProxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        } else {
//            objc_setAssociatedObject(self, &Keys.proxy, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    /// Stores and retrieves the clear-text value when using secure text entry
//    var nonSecureText: String {
//        get {
//            objc_getAssociatedObject(self, &Keys.clear) as? String ?? ""
//        }
//        set {
//            objc_setAssociatedObject(self, &Keys.clear, newValue as NSString, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//}
