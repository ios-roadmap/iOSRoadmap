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
//class MyViewController: UIViewController {
//    private var textFieldProxy: UITextFieldDelegateProxy?
//
//    func setupTextField() {
//        let proxy = UITextFieldDelegateProxy(originalDelegate: textField.delegate)
//
//        proxy.intercept(.didBeginEditing { textField in
//            print("Keyboard opened")
//        })
//
//        textField.delegate = proxy
//        self.textFieldProxy = proxy /// Stored here so it won’t be deallocated
//    }
//}

// MARK: - CRTelephoneInputFieldComponentView ⇢ CRInputFieldDelegate
extension CRTelephoneInputFieldComponentView: CRInputFieldDelegate {

    // --------------------------------------------------------------------
    // Extra caret-math helpers (pure Swift, no Foundation tricks)
    // --------------------------------------------------------------------
    /// How many digits are in `s` *before* the given UTF-16 offset.
    private func digitCount(in s: String, upToUTF16 offset: Int) -> Int {
        var count = 0, pos = 0
        for ch in s {
            pos += ch.utf16.count
            if pos > offset { break }
            if ch.isWholeNumber { count += 1 }
        }
        return count
    }

    /// UTF-16 offset of the digit at `index` (0-based) or of the first
    /// non-digit after the last digit if `index` is past the end.
    private func utf16Offset(ofDigit index: Int, in s: String) -> Int {
        var count = 0, pos = 0
        for ch in s {
            if ch.isWholeNumber {
                if count == index { return pos }
                count += 1
            }
            pos += ch.utf16.count
        }
        return pos
    }

    // --------------------------------------------------------------------
    // Delegate
    // --------------------------------------------------------------------
    public func shouldChangeCharacters(inputField: CRInputField,
                                       in range: NSRange,
                                       with replacement: String) -> Bool {

        // 0. Basic safety
        guard let current = inputField.text,
              let swiftRange = Range(range, in: current) else { return true }

        // 1. Convert “delete a space” into “delete the digit before it”
        var effRange      = range
        var effSwiftRange = swiftRange     // effective ranges we will use
        if replacement.isEmpty, range.length == 1,
           current[swiftRange].allSatisfy({ !$0.isWholeNumber }) {

            // Step left until we hit a digit or the prefix
            var idx = current.index(before: effSwiftRange.lowerBound)
            while idx > current.startIndex,
                  !current[idx].isWholeNumber {
                idx = current.index(before: idx)
            }

            guard current[idx].isWholeNumber else { return false }  // hit prefix
            let loc = current.utf16.distance(from: current.startIndex, to: idx)
            effRange      = NSRange(location: loc, length: 1)
            effSwiftRange = Range(effRange, in: current)!
        }

        // 2. Caret position in “digit coordinates”
        let digitPosBefore = digitCount(in: current, upToUTF16: effRange.location)

        // 3. Build the *unformatted* candidate string
        let candidate = current.replacingCharacters(in: effSwiftRange, with: replacement)
        let local     = localDigits(from: candidate)
        guard local.count <= 10 else { return false }          // max 10 local digits

        // 4. Apply your formatter
        let code   = telephoneInputField?.selectedCountryCode.phoneCode ?? ""
        let target = formatted(code: code, local: local)

        // 5. If the formatter changed something, commit & restore caret
        if inputField.text != target {

            let removedDigits  = current[effSwiftRange].filter(\.isWholeNumber).count
            let insertedDigits = replacement.filter(\.isWholeNumber).count
            let digitPosAfter  = digitPosBefore + insertedDigits - removedDigits

            inputField.text = target

            let caretUTF16  = utf16Offset(ofDigit: digitPosAfter, in: target)
            inputField.setCursorPosition(offset: caretUTF16)

            // (Notify view-model etc. here if you need to.)
            return false                          // we handled the edit
        }

        // 6. Nothing reformatted → let UIKit do the default thing
        return true
    }
}
