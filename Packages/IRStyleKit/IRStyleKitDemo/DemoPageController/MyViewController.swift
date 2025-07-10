//
//  MyViewController.swift
//  SecureMaskDemo
//
//  Created by Omer on 10.07.2025.
//

import UIKit
import ObjectiveC.runtime

// MARK: - Non-secure metni saklama
private extension UITextField {
    private struct Key { static var clear = "nonSecureText" }

    var nonSecureText: String {
        get { objc_getAssociatedObject(self, &Key.clear) as? String ?? "" }
        set { objc_setAssociatedObject(self,
                                       &Key.clear,
                                       newValue as NSString,
                                       .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

// MARK: - VC
import UIKit

final class MyViewController: UIViewController, UITextFieldDelegate, ShowcaseListViewControllerProtocol {
    // MARK: – UI
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        tf.rightView = eyeButton
        tf.rightViewMode = .always
        
        return tf
    }()
    
    // MARK: – Masking
    
    private let bullet = "\u{25CF}"
    private let masker  = MaskedDelegate()                          // your masking interceptor
    private lazy var proxy = Proxy(interceptor: masker, primary: self)
    
    // MARK: – Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // add & layout
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // delegate chain
        passwordTextField.delegate = proxy
        
        // eye action
        if let eyeButton = passwordTextField.rightView as? UIButton {
            eyeButton.addTarget(self, action: #selector(toggleSecure), for: .touchUpInside)
        }
    }
    
    // MARK: – Toggle Secure / Mask
    
    @objc private func toggleSecure() {
        let willSecure = !passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = willSecure
        
        if willSecure {
            proxy.interceptor = masker
            passwordTextField.text = String(repeating: bullet, count: passwordTextField.nonSecureText.count)
            (passwordTextField.rightView as? UIButton)?
                .setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            proxy.interceptor = nil
            passwordTextField.text = passwordTextField.nonSecureText
            (passwordTextField.rightView as? UIButton)?
                .setImage(UIImage(systemName: "eye"), for: .normal)
        }
        
        // fix cursor position
        DispatchQueue.main.async { [weak self] in
            guard let tf = self?.passwordTextField else { return }
            let end = tf.endOfDocument
            tf.selectedTextRange = tf.textRange(from: end, to: end)
        }
    }
    
    // MARK: – UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Submitted: \(textField.nonSecureText)")
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Maskeyi uygulayan delegate
private final class MaskedDelegate: NSObject, UITextFieldDelegate {
    private let bullet = "\u{25CF}"

    func textField(_ tf: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // 1. nonSecureText’i güncelle
        if let current = tf.nonSecureText as NSString? {
            tf.nonSecureText = current.replacingCharacters(in: range, with: string)
        } else {
            tf.nonSecureText = string
        }

        // 2. ●●● göster
        tf.text = String(repeating: bullet, count: tf.nonSecureText.count)

        // 3. caret pozisyonunu koru
        let cursor = range.location + string.utf16.count
        tf.setCursor(offset: cursor)

        // 4. editingChanged event’i
        tf.sendActions(for: .editingChanged)

        return false        // UIKit gerçek karakterleri eklemesin
    }
}

// MARK: - Proxy iki delegate’i birleştirir
private final class Proxy: NSObject, UITextFieldDelegate {
    var interceptor: UITextFieldDelegate?
    private weak var primary: UITextFieldDelegate?

    init(interceptor: UITextFieldDelegate, primary: UITextFieldDelegate?) {
        self.interceptor = interceptor
        self.primary     = primary
    }

    override func responds(to sel: Selector!) -> Bool {
        super.responds(to: sel) ||
        (interceptor?.responds(to: sel) ?? false) ||
        (primary?.responds(to: sel)     ?? false)
    }

    override func forwardingTarget(for sel: Selector!) -> Any? {
        (interceptor?.responds(to: sel) == true) ? interceptor : primary
    }

    // Return-value metotlarını elle yönlendir
    func textField(_ tf: UITextField,
                   shouldChangeCharactersIn r: NSRange,
                   replacementString s: String) -> Bool {
        let iOK = interceptor?.textField?(tf, shouldChangeCharactersIn: r, replacementString: s) ?? true
        let pOK = primary?.textField?(tf, shouldChangeCharactersIn: r, replacementString: s) ?? true
        return iOK && pOK
    }
}

// MARK: - Cursor helper (isteğe bağlı)
private extension UITextField {
    func setCursor(offset: Int) {
        if let pos = position(from: beginningOfDocument, offset: offset) {
            selectedTextRange = textRange(from: pos, to: pos)
        }
    }
}
