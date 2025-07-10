//
//  MyViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 9.07.2025.
//

import UIKit

// MARK: - Proxy delegate
final class SecureFieldProxy: NSObject, UITextFieldDelegate {
    
    /// Stores the real text the user typed
    private(set) var plainText = ""
    
    /// Forward everything we don’t override to another delegate (optional)
    weak var forward: UITextFieldDelegate?
    
    // Intercept every keystroke _before_ UIKit commits it
    func textField(_ tf: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // 1. Compute what the new string would be
        if let current = tf.text as NSString? {
            plainText = current.replacingCharacters(in: range, with: string)
        } else {
            plainText = string
        }
        
        // 2. Replace the field’s visible text with bullets immediately
        tf.text = String(repeating: "•", count: plainText.count)
        
        // 3. Send the usual editingChanged control event so observers still fire
        tf.sendActions(for: .editingChanged)
        
        // 4. Tell UIKit _not_ to insert the real character it was about to show
        return false
    }
    
    // ----------  Boiler-plate forwarding ----------
    override func responds(to sel: Selector!) -> Bool {
        super.responds(to: sel) || (forward?.responds(to: sel) ?? false)
    }
    override func forwardingTarget(for sel: Selector!) -> Any? { forward }
}
//---------------------------------------------------

final class MyViewController: UIViewController, ShowcaseListViewControllerProtocol {
    
    private let passwordField      = UITextField()
    private let secondSecureField  = UITextField()
    private let proxy              = SecureFieldProxy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // ------------ first field (proxy) ------------
        configure(textField: passwordField,
                  placeholder: "Proxy-masked password",
                  usesProxy: true)
        
        // ------------ second field (normal secure) ------------
        configure(textField: secondSecureField,
                  placeholder: "Native isSecureTextEntry",
                  usesProxy: false)
        
        // ------------ layout ------------
        let stack = UIStackView(arrangedSubviews: [passwordField,
                                                   secondSecureField])
        stack.axis         = .vertical
        stack.spacing      = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor .constraint(equalToConstant: 240)
        ])
    }
    
    // MARK: helper
    private func configure(textField: UITextField,
                           placeholder: String,
                           usesProxy: Bool) {
        
        textField.placeholder              = placeholder
        textField.isSecureTextEntry        = true          // always set
        textField.textContentType          = .password
        textField.autocapitalizationType   = .none
        textField.autocorrectionType       = .no
        textField.spellCheckingType        = .no
        textField.keyboardType             = .asciiCapable
        textField.enablesReturnKeyAutomatically = true
        textField.borderStyle              = .roundedRect
        
        if usesProxy {
            textField.delegate = proxy
            textField.clearsOnBeginEditing = true
            textField.clearsOnInsertion = true
        }
    }
}
