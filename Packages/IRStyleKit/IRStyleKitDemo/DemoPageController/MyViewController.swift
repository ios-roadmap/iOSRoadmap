//
//  MaskedTextFieldDemo.swift
//  SecureMaskDemo
//
//  Created by Omer on 10.07.2025.
//

import UIKit
import ObjectiveC.runtime

// MARK: - Delegate Proxy

public protocol CRTextFieldInterceptor: AnyObject, UITextFieldDelegate {}

public final class CRTextFieldDelegateProxy: NSObject, UITextFieldDelegate {
    public weak var interceptor: CRTextFieldInterceptor?
    private weak var primary: UITextFieldDelegate?

    public init(interceptor: CRTextFieldInterceptor?, primary: UITextFieldDelegate?) {
        self.interceptor = interceptor
        self.primary = primary
        super.init()
    }

    public override func responds(to sel: Selector!) -> Bool {
        super.responds(to: sel) ||
        interceptor?.responds(to: sel) == true ||
        primary?.responds(to: sel) == true
    }

    public override func forwardingTarget(for sel: Selector!) -> Any? {
        if interceptor?.responds(to: sel) == true { return interceptor }
        if primary?.responds(to: sel) == true     { return primary }
        return nil
    }

    // Forward return‑value methods manually
    public func textField(_ tf: UITextField,
                          shouldChangeCharactersIn r: NSRange,
                          replacementString s: String) -> Bool {
        let iOK = interceptor?.textField?(tf, shouldChangeCharactersIn: r, replacementString: s) ?? true
        let pOK = primary?.textField?(tf, shouldChangeCharactersIn: r, replacementString: s) ?? true
        return iOK && pOK
    }
}

// MARK: - Proxy helpers

public extension UITextField {
    private struct Keys {
        static var proxy = "cr_proxy_key"
        static var clear = "cr_non_secure"
    }

    func attachProxy(interceptor: CRTextFieldInterceptor?,
                     primary: UITextFieldDelegate? = nil) {
        let proxy = CRTextFieldDelegateProxy(interceptor: interceptor,
                                             primary: primary ?? delegate)
        delegate = proxy
        objc_setAssociatedObject(self,
                                 &Keys.proxy,
                                 proxy,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func currentProxy() -> CRTextFieldDelegateProxy? {
        objc_getAssociatedObject(self, &Keys.proxy) as? CRTextFieldDelegateProxy
    }
}

// MARK: - Clear text store

private extension UITextField {

    var nonSecureText: String {
        get { objc_getAssociatedObject(self, &Keys.clear) as? String ?? "" }
        set {
            objc_setAssociatedObject(self,
                                     &Keys.clear,
                                     newValue as NSString,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Masking interceptor

final class MaskedInterceptor: NSObject, CRTextFieldInterceptor {
    private let bullet = "\u{25CF}"
    var isMaskingEnabled = true

    func textField(_ tf: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // 1. Compute clear value
        let clearResult = (tf.nonSecureText as NSString)
            .replacingCharacters(in: range, with: string)
        tf.nonSecureText = clearResult

        // 2. Mask ON → bullets & prevent default insertion
        if isMaskingEnabled {
            tf.text = String(repeating: bullet, count: clearResult.count)
            let cursor = range.location + string.utf16.count
            tf.setCursor(offset: cursor)
            tf.sendActions(for: .editingChanged)
            return false
        }

        // 3. Mask OFF → let UIKit insert
        return true
    }
}

// MARK: - Cursor helper
private extension UITextField {
    func setCursor(offset: Int) {
        if let pos = position(from: beginningOfDocument, offset: offset) {
            selectedTextRange = textRange(from: pos, to: pos)
        }
    }
}

// MARK: - Example VC

final class MyViewController: UIViewController, ShowcaseListViewControllerProtocol {
    // UI: secure field
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false

        let eye = UIButton(type: .system)
        eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        tf.rightView = eye
        tf.rightViewMode = .always
        return tf
    }()

    // UI: print button
    private let printButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Print Text", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    // Masking
    private let interceptor = MaskedInterceptor()

    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Layout subviews
        view.addSubview(passwordTextField)
        view.addSubview(printButton)

        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            printButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            printButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Attach proxy once
        passwordTextField.attachProxy(interceptor: interceptor)

        // Toggle eye
        (passwordTextField.rightView as? UIButton)?
            .addTarget(self, action: #selector(toggleSecure), for: .touchUpInside)

        // Submit via Return
        passwordTextField.addTarget(self,
                                    action: #selector(submit),
                                    for: .primaryActionTriggered)

        // Print via button
        printButton.addTarget(self, action: #selector(printText), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func toggleSecure() {
        let willSecure = !passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = willSecure
        interceptor.isMaskingEnabled = willSecure

        if willSecure {
            passwordTextField.text = String(repeating: "\u{25CF}", count: passwordTextField.nonSecureText.count)
            (passwordTextField.rightView as? UIButton)?.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordTextField.text = passwordTextField.nonSecureText
            (passwordTextField.rightView as? UIButton)?.setImage(UIImage(systemName: "eye"), for: .normal)
        }

        DispatchQueue.main.async { [weak self] in
            guard let tf = self?.passwordTextField else { return }
            let end = tf.endOfDocument
            tf.selectedTextRange = tf.textRange(from: end, to: end)
        }
    }

    @objc private func submit() {
        print("Submitted clear text:", passwordTextField.nonSecureText)
        view.endEditing(true)
    }

    @objc private func printText() {
        print("Current clear text:", passwordTextField.nonSecureText)
        // Optionally show an alert so the user sees it on‑screen
        let alert = UIAlertController(title: "Clear Text",
                                      message: passwordTextField.nonSecureText,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
