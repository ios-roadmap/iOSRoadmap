//import UIKit
//import ObjectiveC
//import CRCore
//
//public extension UITextField {
//    // MARK: - Associated‑object keys
//    private struct Keys {
//        static var proxy = 0   // stores the outer‑most CRTextFieldDelegateProxy
//        static var clear = 1   // stores clear text when secure entry is on
//    }
//
//    // MARK: - Convenience getter
//
//    /// Returns the outer‑most `CRTextFieldDelegateProxy`, if any.
//    var currentMaskedProxy: CRTextFieldDelegateProxy? {
//        objc_getAssociatedObject(self, &Keys.proxy) as? CRTextFieldDelegateProxy
//    }
//
//    // MARK: - Attach
//
//    /// Wraps the current `delegate` in a new `CRTextFieldDelegateProxy` so you can stack masks.
//    /// - Parameters:
//    ///   - interceptor: Concrete `CRMaskedInputFieldDelegate` that also conforms to `UITextFieldDelegate`.
//    ///   - didChangeMaskState: Optional callback fired when mask completion state changes.
//    /// - Returns: The proxy that was just created. Store it if you want to remove exactly that layer later.
//    @discardableResult
//    func attachMaskedDelegate(
//        interceptor: (CRMaskedInputFieldDelegate & UITextFieldDelegate)?,
//        didChangeMaskState: CRGenericClosure<CRMaskModels.MaskCompletionState>? = nil
//    ) -> CRTextFieldDelegateProxy? {
//        interceptor?.didChangeMaskState = didChangeMaskState
//        let newProxy = CRTextFieldDelegateProxy(interceptor: interceptor, primary: delegate)
//        text = interceptor?.initialText
//        delegate = newProxy
//
//        // Keep a strong reference to the topmost proxy.
//        objc_setAssociatedObject(self, &Keys.proxy, newProxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        interceptor?.handleMaskCompletionState(didChangeMaskState)
//        return newProxy
//    }
//
//    // MARK: - Detach (pop‑style)
//
//    /// Removes ONLY the outer‑most proxy (LIFO behaviour).
//    func detachMaskedDelegate() {
//        guard let top = currentMaskedProxy else { return }
//        replace(topProxy: top, with: top.primary)
//    }
//
//    // MARK: - Detach by exact proxy reference
//
//    /// Removes the given proxy instance if it exists in the chain.
//    func detachMaskedDelegate(_ proxyToRemove: CRTextFieldDelegateProxy) {
//        detachProxy(where: { $0 === proxyToRemove })
//    }
//
//    // MARK: - Detach by interceptor INSTANCE
//
//    /// Removes the first proxy in the chain whose `interceptor` **is exactly** the instance provided.
//    func detachMaskedDelegate(interceptor target: CRMaskedInputFieldDelegate) {
//        // 1. Start with whatever is currently the UITextField's delegate.
//        guard var current = delegate as? CRTextFieldDelegateProxy else { return }
//        var previous: CRTextFieldDelegateProxy? = nil
//
//        while true {
//            // 2. Found the proxy whose interceptor matches the target?
//            if let masked = current.interceptor, masked === target {
//                if previous == nil {
//                    // A) The matching proxy is the OUTER‑MOST layer.
//                    replace(topProxy: current, with: current.primary)
//                } else if let prev = previous {
//                    // B) The matching proxy is somewhere in the middle.
//                    prev.primary = current.primary // bypass `current`
//                }
//                return // stop after removing the first match
//            }
//
//            // 3. Move down one layer. If there is no next proxy, exit.
//            guard let next = current.primary as? CRTextFieldDelegateProxy else { return }
//            previous = current
//            current  = next
//        }
//    }
//
//    // MARK: - Detach by interceptor TYPE
//
//    /// Removes the first proxy whose interceptor is of the specified type.
//    func detachMaskedDelegate<Masked: CRMaskedInputFieldDelegate>(ofType type: Masked.Type) {
//        detachProxy { $0.interceptor is Masked }
//    }
//
//    // MARK: - Clear‑text mirror when secure entry is enabled
//
//    var nonSecureText: String {
//        get { objc_getAssociatedObject(self, &Keys.clear) as? String ?? "" }
//        set { objc_setAssociatedObject(self, &Keys.clear, newValue as NSString, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
//    }
//
//    // MARK: - Private helpers
//
//    /// Traverses the proxy chain and removes the first proxy that satisfies `matcher`.
//    private func detachProxy(where matcher: (CRTextFieldDelegateProxy) -> Bool) {
//        guard let head = currentMaskedProxy else { return }
//
//        // Special case: the head is the match.
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
//                // Bypass `cur` by linking `previous` directly to whatever `cur` wraps.
//                previous.primary = cur.primary
//                return
//            }
//            previous = cur
//            current  = cur.primary as? CRTextFieldDelegateProxy
//        }
//    }
//
//    /// Replaces the UITextField's stored top proxy when removing the current outer‑most layer.
//    private func replace(topProxy: CRTextFieldDelegateProxy, with newDelegate: UITextFieldDelegate?) {
//        delegate = newDelegate // apply the new delegate (may be proxy or real)
//
//        // Update the associated object: keep it only if the new delegate is still a proxy.
//        if let nextProxy = newDelegate as? CRTextFieldDelegateProxy {
//            objc_setAssociatedObject(self, &Keys.proxy, nextProxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        } else {
//            objc_setAssociatedObject(self, &Keys.proxy, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//}
