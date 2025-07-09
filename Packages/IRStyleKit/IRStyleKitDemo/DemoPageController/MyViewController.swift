//
//  MyViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 9.07.2025.
//

import UIKit

// MARK: - UITextFieldDelegate that never reveals a digit
final class SecureNumberDelegate: NSObject, UITextFieldDelegate {

    /// Raw numeric value exactly as the user typed it.
    private(set) var value = ""

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        guard
            let current = textField.text,
            let swiftRange = Range(range, in: current)
        else { return false }

        // Reject anything that isn’t a decimal digit or back-space
        if !string.isEmpty,
           !string.unicodeScalars.allSatisfy(CharacterSet.decimalDigits.contains) {
            return false
        }

        // Update the stored value exactly as the user edited
        value.replaceSubrange(swiftRange, with: string)

        // Draw the same number of • symbols so nothing is ever revealed
        textField.text = String(repeating: "•", count: value.count)
        return false           // we handled the visual change ourselves
    }
}

// MARK: - View controller that uses the delegate
final class MyViewController: UIViewController, ShowcaseListViewControllerProtocol {

    private let secureDelegate = SecureNumberDelegate()

    private lazy var pinField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder           = "Enter PIN"
        field.borderStyle           = .roundedRect
        field.keyboardType          = .numberPad
        field.isSecureTextEntry     = true          // keep system safeguards
        field.autocorrectionType    = .no
        field.spellCheckingType     = .no
        field.delegate              = secureDelegate
        return field
    }()

    private lazy var submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Submit", for: .normal)
        btn.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return btn
    }()

    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(pinField)
        view.addSubview(submitButton)

        NSLayoutConstraint.activate([
            pinField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pinField.widthAnchor.constraint(equalToConstant: 200),

            submitButton.topAnchor.constraint(equalTo: pinField.bottomAnchor, constant: 24),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: – Actions
    @objc private func handleSubmit() {
        let pin = secureDelegate.value
        // Handle `pin` securely (hash, send to backend, etc.)
        print("Entered PIN:", pin)
    }
}
