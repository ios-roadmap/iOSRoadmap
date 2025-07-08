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

private func prefix(for code: String) -> String {
       "+\(code) "
   }

   private func firstLocalUTF16Index(for code: String) -> Int {
       prefix(for: code).utf16.count
   }

   private func localDigits(from text: String) -> String {
       text.onlyDigits()
   }

   private func formatted(code: String, local: String) -> String {
       let trimmed = String(local.prefix(10))
       let groups = code == "90" ? [3,3,2,2] : []
       var out = ""
       var idx = trimmed.startIndex

       for len in groups where idx < trimmed.endIndex {
           let end = trimmed.index(idx, offsetBy: len, limitedBy: trimmed.endIndex) ?? trimmed.endIndex
           out += (out.isEmpty ? "" : " ") + trimmed[idx..<end]
           idx = end
       }
       if idx < trimmed.endIndex {
           out += (out.isEmpty ? "" : " ") + trimmed[idx...]
       }
       return prefix(for: code) + out
   }

   public func shouldChangeCharacters(inputField: CRInputField,
                                      in range: NSRange,
                                      with replacement: String) -> Bool {
       guard let current = inputField.text,
             let swiftRange = Range(range, in: current) else {
           return true
       }

       let code = telephoneInputField?.selectedCountryCode.phoneCode ?? ""
       let prefixText = prefix(for: code)
       let prefixLen = prefixText.utf16.count

       // 1) İlk yerel basamağı silme ⇒ sadece prefix, imleç orada kalır
       if replacement.isEmpty,
          range.length == 1,
          range.location == prefixLen {

           inputField.text = prefixText
           inputField.setCursorPosition(offset: prefixLen)

           telephoneInputField?.delegate = nil
           _ = telephoneInputField?.shouldChangeCharacters(in: range, with: replacement)
           telephoneInputField?.delegate = self
           viewModel.viewModelDelegate?.currentPhoneNumber(from: phoneNumber)
           return false
       }

       // 2) Normal akış: metni güncelle − sadece rakamları al − uzunluk sınırı
       let next = current.replacingCharacters(in: swiftRange, with: replacement)
       let local = localDigits(from: next)
       guard local.count <= 10 else { return false }

       // 3) Edit öncesi local içindeki caret pozisyonu
       let before = String(current[..<swiftRange.lowerBound])
       let cursorInLocal = localDigits(from: before).count

       // 4) Format uygula
       let target = formatted(code: code, local: local)
       if target != current {
           inputField.text = target

           // 5) İmleci yeniden hesapla
           var offset = prefixLen
           var rem = cursorInLocal
           let groups = code == "90" ? [3,3,2,2] : []

           if groups.isEmpty {
               offset += rem
           } else {
               for g in groups {
                   if rem > g {
                       offset += g + 1   // g rakam + 1 space
                       rem -= g
                   } else {
                       offset += rem
                       rem = 0
                       break
                   }
               }
               // kalan rem, gruplar toplamını aşarsa (nadiren)
               if rem > 0 {
                   offset += rem
               }
           }
           inputField.setCursorPosition(offset: offset)

           telephoneInputField?.delegate = nil
           _ = telephoneInputField?.shouldChangeCharacters(in: range, with: replacement)
           telephoneInputField?.delegate = self
           viewModel.viewModelDelegate?.currentPhoneNumber(from: phoneNumber)
           return false
       }

       // 6) Format değişmediyse sadece forward et
       telephoneInputField?.delegate = nil
       let should = telephoneInputField?.shouldChangeCharacters(in: range, with: replacement) ?? true
       telephoneInputField?.delegate = self
       return should
   }
}
