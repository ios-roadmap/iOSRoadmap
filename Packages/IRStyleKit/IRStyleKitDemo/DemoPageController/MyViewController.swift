//
//  MyViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 9.07.2025.
//

import UIKit

// MARK: - Proxy delegate
final class SecureFieldProxy: NSObject, UITextFieldDelegate {
    
    /// The user’s real input (digits, characters, etc.)
    private(set) var value = ""
    
    /// The symbol used to mask each character
    private let bullet = "\u{25CF}"  // ●
    
    /// Optional real delegate to forward unhandled calls to
    weak var forward: UITextFieldDelegate?
    
    func textField(_ tf: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // 1. Compute the new raw value
        if let current = tf.text as NSString? {
            value = current.replacingCharacters(in: range, with: string)
        } else {
            value = string
        }
        
        // 2. Update the visible text with bullets
        tf.text = String(repeating: bullet, count: value.count)
        
        // 3. Fire editingChanged so observers still work
        tf.sendActions(for: .editingChanged)
        
        // 4. Prevent UIKit from inserting the real text
        return false
    }
    
    // MARK: - Boilerplate for forwarding other delegate methods
    
    override func responds(to sel: Selector!) -> Bool {
        return super.responds(to: sel) || (forward?.responds(to: sel) ?? false)
    }
    
    override func forwardingTarget(for sel: Selector!) -> Any? {
        return forward
    }
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
