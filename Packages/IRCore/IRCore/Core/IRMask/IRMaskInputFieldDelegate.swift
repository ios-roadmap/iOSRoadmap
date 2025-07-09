//
//  IRMaskInputFieldDelegate.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 28.02.2025.
//

// ViewController.swift
import UIKit

/// Masks every digit input with • and keeps the real value internally.
class SecureNumberDelegate: NSObject, UITextFieldDelegate {
    private(set) var realText = ""

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string.isEmpty {
            // Deletion
            if !realText.isEmpty {
                realText.removeLast()
            }
        } else {
            // Only allow digits
            guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
            realText.append(string)
        }
        // Always show bullets only
        textField.text = String(repeating: "•", count: realText.count)
        return false
    }
}

class MyViewController: UIViewController {
    private let secureDelegate = SecureNumberDelegate()

    private let pinField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter PIN"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        // We're handling masking ourselves:
        tf.isSecureTextEntry = false
        return tf
    }()

    private let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Submit", for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(pinField)
        view.addSubview(submitButton)

        pinField.delegate = secureDelegate
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)

        NSLayoutConstraint.activate([
            pinField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pinField.widthAnchor.constraint(equalToConstant: 200),

            submitButton.topAnchor.constraint(equalTo: pinField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc private func handleSubmit() {
        let enteredPIN = secureDelegate.realText
        print("Entered PIN:", enteredPIN)
        // …use the PIN securely…
    }
}
