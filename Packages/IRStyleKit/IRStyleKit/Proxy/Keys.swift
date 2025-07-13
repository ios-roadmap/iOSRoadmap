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
//    //  MARK: - Detach by interceptor INSTANCE
//    func detachMaskedDelegate(interceptor target: CRMaskedInputFieldDelegate) {
//        // 1. zincirin en üstündeki delegate’ten başla
//        guard var current = delegate as? CRTextFieldDelegateProxy else { return }
//        var previous: CRTextFieldDelegateProxy? = nil
//
//        while true {
//            /// Bulduk mu?
//            if let masked = current.interceptor, masked === target {
//                // A) Kaldırılacak katman EN ÜST katmansa
//                if previous == nil {
//                    delegate = current.primary        // top’u atla
//                    //  delegate’nin yeni değeri hâlâ proxy ise sakla, değilse temizle
//                    if delegate is CRTextFieldDelegateProxy {
//                        objc_setAssociatedObject(self, &Keys.proxy, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                    } else {
//                        objc_setAssociatedObject(self, &Keys.proxy, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                    }
//                }
//                // B) Aradaki (middle) katmansa
//                else if let prev = previous {
//                    prev.primary = current.primary    // zinciri yeniden bağla
//                }
//                return                                // sadece bir eşleşme sökülür
//            }
//
//            // Sonraki halkaya in
//            guard let next = current.primary as? CRTextFieldDelegateProxy else { return }
//            previous = current
//            current  = next
//        }
//    }
//
//}
