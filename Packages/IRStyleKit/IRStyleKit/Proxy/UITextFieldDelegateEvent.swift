//
//  UITextFieldDelegateEvent.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 3.07.2025.
//


import UIKit

// MARK: - Delegate Events (Type-safe)
enum UITextFieldDelegateEvent {
    case didChangeSelection((_ textField: UITextField) -> Void)
    case didBeginEditing((_ textField: UITextField) -> Void)
    case didEndEditing((_ textField: UITextField) -> Void)
    case shouldChangeCharacters(((UITextField, NSRange, String) -> Bool))
}

// MARK: - Proxy Class
final class UITextFieldDelegateProxy: NSObject, UITextFieldDelegate {
    weak var originalDelegate: UITextFieldDelegate?

    private var didChangeSelectionHandler: ((UITextField) -> Void)?
    private var didBeginEditingHandler: ((UITextField) -> Void)?
    private var didEndEditingHandler: ((UITextField) -> Void)?
    private var shouldChangeCharactersHandler: ((UITextField, NSRange, String) -> Bool)?

    init(originalDelegate: UITextFieldDelegate?) {
        self.originalDelegate = originalDelegate
    }

    func intercept(_ event: UITextFieldDelegateEvent) {
        switch event {
        case .didChangeSelection(let handler):
            didChangeSelectionHandler = handler
        case .didBeginEditing(let handler):
            didBeginEditingHandler = handler
        case .didEndEditing(let handler):
            didEndEditingHandler = handler
        case .shouldChangeCharacters(let handler):
            shouldChangeCharactersHandler = handler
        }
    }

    // MARK: - UITextFieldDelegate Methods

    func textFieldDidChangeSelection(_ textField: UITextField) {
        didChangeSelectionHandler?(textField)
        originalDelegate?.textFieldDidChangeSelection?(textField)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditingHandler?(textField)
        originalDelegate?.textFieldDidBeginEditing?(textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditingHandler?(textField)
        originalDelegate?.textFieldDidEndEditing?(textField)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let handler = shouldChangeCharactersHandler {
            return handler(textField, range, string)
        }
        return originalDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    // MARK: - Message Forwarding

    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        case #selector(textFieldDidChangeSelection(_:)):
            return didChangeSelectionHandler != nil || (originalDelegate?.responds(to: aSelector) ?? false)
        case #selector(textFieldDidBeginEditing(_:)):
            return didBeginEditingHandler != nil || (originalDelegate?.responds(to: aSelector) ?? false)
        case #selector(textFieldDidEndEditing(_:)):
            return didEndEditingHandler != nil || (originalDelegate?.responds(to: aSelector) ?? false)
        case #selector(textField(_:shouldChangeCharactersIn:replacementString:)):
            return shouldChangeCharactersHandler != nil || (originalDelegate?.responds(to: aSelector) ?? false)
        default:
            return originalDelegate?.responds(to: aSelector) ?? false
        }
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return originalDelegate
    }
}

// MARK: - UITextField Extension with Proxy

private var proxyKey: UInt8 = 0

extension UITextField {
    /// Adds a proxy as the delegate of the UITextField, allowing you to intercept specific delegate events
    /// using type-safe closures. This proxy is retained automatically using associated objects,
    /// so you don't need to store it manually.
    ///
    /// Usage:
    /// ```swift
    /// textField.useDelegateProxy { proxy in
    ///     proxy.intercept(.didBeginEditing { textField in
    ///         print("Editing began.")
    ///     })
    ///     proxy.intercept(.didChangeSelection { textField in
    ///         print("Cursor moved.")
    ///     })
    /// }
    /// ```
    func useDelegateProxy(configure: (UITextFieldDelegateProxy) -> Void) {
        let proxy = UITextFieldDelegateProxy(originalDelegate: self.delegate)
        configure(proxy)
        self.delegate = proxy
        objc_setAssociatedObject(self, &proxyKey, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

/// UITextFieldDelegateProxy must always be stored as a property, otherwise it gets deallocated immediately.
/// If you declare it only as a local variable (for example `let proxy = …`),
/// ARC (Automatic Reference Counting) will deallocate it when the scope ends.
/// Even if you set `textField.delegate = proxy`, that alone is not enough,
/// because UIKit does not retain (own) its delegate.
///
/// ✅ Correct usage: keep the proxy as a class-level property
class MyViewController: UIViewController {
    private var textFieldProxy: UITextFieldDelegateProxy?

    func setupTextField() {
        let proxy = UITextFieldDelegateProxy(originalDelegate: textField.delegate)

        proxy.intercept(.didBeginEditing { textField in
            print("Keyboard opened")
        })

        textField.delegate = proxy
        self.textFieldProxy = proxy /// Stored here so it won’t be deallocated
    }
}
