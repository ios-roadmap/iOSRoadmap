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

class PhoneFormatterViewController: UIViewController, CRInputFieldDelegate {

    @IBOutlet weak var telephoneInputField: CRInputField!
    private var isFormatting = false

    override func viewDidLoad() {
        super.viewDidLoad()
        telephoneInputField.delegate = self
        telephoneInputField.keyboardType = .phonePad
    }

    // Helpers omitted for brevity: prefix(for:), firstLocalUTF16Index(for:), localDigits(from:), formatted(code:local:)

    func shouldChangeCharacters(inputField: CRInputField,
                                in range: NSRange,
                                with replacement: String) -> Bool {
        // 1. If we’re already formatting, let the change through unmodified
        if isFormatting {
            return true
        }

        guard let current = inputField.text,
              let swiftRange = Range(range, in: current) else {
            return true
        }

        let code = telephoneInputField.selectedCountryCode.phoneCode
        let prefixText = prefix(for: code)
        let prefixLen = prefixText.utf16.count

        // 2. Special-case deleting the very first local digit
        if replacement.isEmpty,
           range.length == 1,
           range.location <= prefixLen {
            isFormatting = true
            inputField.text = prefixText
            inputField.setCursorPosition(offset: prefixLen)
            isFormatting = false
            viewModel.viewModelDelegate?.currentPhoneNumber(from: phoneNumber)
            return false
        }

        // 3. Compute the “next” raw string and strip to digits
        let next = current.replacingCharacters(in: swiftRange, with: replacement)
        let local = localDigits(from: next)
        guard local.count <= 10 else { return false }

        // 4. Calculate where the cursor was in the unformatted digits
        let beforeEdit = String(current[..<swiftRange.lowerBound])
        let cursorInLocal = localDigits(from: beforeEdit).count

        // 5. Build the formatted string
        let target = formatted(code: code, local: local)

        // 6. If formatting changed the visible text, apply it
        if target != current {
            isFormatting = true
            inputField.text = target

            // Recompute cursor offset in the formatted string
            var offset = prefixLen
            var rem = cursorInLocal
            let groups = code == "90" ? [3,3,2,2] : []
            if groups.isEmpty {
                offset += rem
            } else {
                for g in groups {
                    if rem > g {
                        offset += g + 1 // +1 for the space
                        rem -= g
                    } else {
                        offset += rem
                        rem = 0
                        break
                    }
                }
                if rem > 0 { offset += rem }
            }
            inputField.setCursorPosition(offset: offset)

            isFormatting = false
            viewModel.viewModelDelegate?.currentPhoneNumber(from: phoneNumber)
            return false
        }

        // 7. No formatting change: let it through
        return true
    }
}
