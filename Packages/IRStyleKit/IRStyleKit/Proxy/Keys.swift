//import UIKit
//import ObjectiveC
//import CRCore
//
//public extension UITextField {
//    // MARK: - Associated‑object keys
//    private struct Keys {
//        static var proxy = 0   // holds the outer‑most CRTextFieldDelegateProxy
//        static var clear = 1   // mirrors clear text when using secure entry
//    }
//
//    // MARK: - Convenience getters
//
//    /// Returns the outer‑most `CRTextFieldDelegateProxy`, if any
//    var currentMaskedProxy: CRTextFieldDelegateProxy? {
//        objc_getAssociatedObject(self, &Keys.proxy) as? CRTextFieldDelegateProxy
//    }
//
//    // MARK: - Attach
//
//    /// Wraps the existing `delegate` in a new `CRTextFieldDelegateProxy`.
//    /// The new proxy sits on top of any previous proxies, so you can "stack" them.
//    /// - Parameters:
//    ///   - interceptor: The concrete `CRMaskedInputFieldDelegate` (e.g. `CRSecureMaskedDelegate`)‑
//    ///                  which *also* conforms to `UITextFieldDelegate`.
//    ///   - didChangeMaskState:  Optional callback fired when the mask completion state changes.
//    /// - Returns: The proxy just created. Keep it if you want to detach by *reference* later.
//    @discardableResult
//    func attachMaskedDelegate(
//        interceptor: (CRMaskedInputFieldDelegate & UITextFieldDelegate)?,
//        didChangeMaskState: CRGenericClosure<CRMaskModels.MaskCompletionState>? = nil
//    ) -> CRTextFieldDelegateProxy? {
//        interceptor?.didChangeMaskState = didChangeMaskState
//
//        let newProxy = CRTextFieldDelegateProxy(interceptor: interceptor, primary: delegate)
//        text = interceptor?.initialText
//        delegate = newProxy
//
//        // persist outer‑most proxy
//        objc_setAssociatedObject(self, &Keys.proxy, newProxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        interceptor?.handleMaskCompletionState(didChangeMaskState)
//        return newProxy
//    }
//
//    // MARK: - Detach helpers
//
//    /// Pops ONLY the outer‑most proxy (LIFO behaviour).
//    func detachMaskedDelegate() {
//        guard let top = currentMaskedProxy else { return }
//        replace(topProxy: top, with: top.primary)
//    }
//
//    /// Detaches a *specific* proxy instance, wherever it is in the chain.
//    /// - Parameter proxyToRemove: The proxy instance you received from `attachMaskedDelegate`.
//    func detachMaskedDelegate(_ proxyToRemove: CRTextFieldDelegateProxy) {
//        detachProxy(where: { $0 === proxyToRemove })
//    }
//
//    /// Detaches the first proxy whose *interceptor instance* equals the one provided.
//    /// Useful when you hold on to the masked delegate rather than the proxy.
//    func detachMaskedDelegate(interceptor instance: CRMaskedInputFieldDelegate) {
//        detachProxy { $0.interceptor === instance }
//    }
//
//    /// Detaches the first proxy whose interceptor is of a given TYPE (e.g. `CRSecureMaskedDelegate.self`).
//    func detachMaskedDelegate<Masked: CRMaskedInputFieldDelegate>(ofType type: Masked.Type) {
//        detachProxy { $0.interceptor is Masked }
//    }
//
//    // MARK: - nonSecureText mirror
//
//    /// Stores and retrieves clear‑text when `.isSecureTextEntry` is enabled.
//    var nonSecureText: String {
//        get { objc_getAssociatedObject(self, &Keys.clear) as? String ?? "" }
//        set { objc_setAssociatedObject(self, &Keys.clear, newValue as NSString, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
//    }
//
//    // MARK: - Private helpers
//
//    /// Traverses the proxy chain and removes the first proxy matching `matcher`.
//    private func detachProxy(where matcher: (CRTextFieldDelegateProxy) -> Bool) {
//        guard let head = currentMaskedProxy else { return }
//
//        // Special‑case: the head matches
//        if matcher(head) {
//            replace(topProxy: head, with: head.primary)
//            return
//        }
//
//        // Walk the chain looking for a match deeper down.
//        var previous: CRTextFieldDelegateProxy = head
//        var current = head.primary as? CRTextFieldDelegateProxy
//        while let cur = current {
//            if matcher(cur) {
//                // Bypass `cur` → link `previous` directly to whatever `cur` was wrapping.
//                previous.primary = cur.primary
//                return
//            }
//            previous = cur
//            current = cur.primary as? CRTextFieldDelegateProxy
//        }
//    }
//
//    /// Replaces the *stored* top proxy if the original top is being removed.
//    private func replace(topProxy: CRTextFieldDelegateProxy, with newDelegate: UITextFieldDelegate?) {
//        delegate = newDelegate // put the new delegate (proxy or real) on the UITextField
//
//        // Update the associated object: if newDelegate is another proxy keep it, else clear.
//        if let nextProxy = newDelegate as? CRTextFieldDelegateProxy {
//            objc_setAssociatedObject(self, &Keys.proxy, nextProxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        } else {
//            objc_setAssociatedObject(self, &Keys.proxy, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//}
