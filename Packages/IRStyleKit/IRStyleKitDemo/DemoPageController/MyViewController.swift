//
//  MyViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 9.07.2025.
//

import UIKit

// MARK: - SecureNumberDelegate
/// Masks every digit instantly with ● and keeps the real value.
final class SecureNumberDelegate: NSObject, UITextFieldDelegate {

    private(set) var value = ""           // raw digits
    private let bullet = "\u{25CF}"       // big bullet symbol ●

    // Block copy / cut / paste / drag
    func textField(_ textField: UITextField,
                   canPerformAction action: Selector,
                   withSender sender: Any?) -> Bool { false }

    // Disable caret + drag-and-drop loupe
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.textDragInteraction?.isEnabled = false
        textField.tintColor = .clear
        return true
    }

    // Intercept every keystroke
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // Allow only digits or back-space
        guard string.isEmpty || string.allSatisfy(\.isNumber) else { return false }

        // Update stored digits
        if let swiftRange = Range(range, in: textField.text ?? "") {
            value.replaceSubrange(swiftRange, with: string)
        }

        // Show only bullets (no flash)
        textField.text = String(repeating: bullet, count: value.count)
        return false                                // we handled the UI
    }
}

// MARK: - MyViewController
final class MyViewController: UIViewController, ShowcaseListViewControllerProtocol {

    private let secureDelegate = SecureNumberDelegate()

    // Secure PIN input field (UITextField)
    private lazy var pinField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false // Use Auto Layout constraints
        tf.placeholder        = "Enter PIN"   // Gray hint text shown when the field is empty
        tf.borderStyle        = .roundedRect  // Default rounded rectangle border style
        tf.keyboardType       = .numberPad    // Display number pad keyboard
        tf.isSecureTextEntry  = true          // Obscure text input (e.g., ••••)
        tf.autocorrectionType = .no           // Disable autocorrection
        tf.smartQuotesType    = .no           // Disable smart quotes (keeps raw digits)
        tf.smartDashesType    = .no           // Disable smart dashes
        tf.spellCheckingType  = .no           // Disable spell checking
        tf.delegate           = secureDelegate // Assign delegate (for custom logic or validation)
        return tf
    }()

    // Simple submit button
    private lazy var submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Submit", for: .normal)
        btn.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return btn
    }()

    // Basic view setup
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(pinField)
        view.addSubview(submitButton)

        // Auto-layout constraints
        NSLayoutConstraint.activate([
            pinField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pinField.widthAnchor.constraint(equalToConstant: 200),

            submitButton.topAnchor.constraint(equalTo: pinField.bottomAnchor, constant: 24),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // Read the masked value
    @objc private func handleSubmit() {
        let pin = secureDelegate.value        // full PIN is here
        print("PIN:", pin)                    // replace with secure handling
    }
}
