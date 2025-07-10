//
//  MyViewController.swift
//  SecureMaskDemo
//
//  Created by Omer on 10.07.2025.
//

import UIKit
import ObjectiveC.runtime

// MARK: - UITextField + SecureMask
extension UITextField {

    // MARK: Public API --------------------------------------------------------

    /// The user’s real, unmasked input.
    public var realText: String {
        get { objc_getAssociatedObject(self, &AssociatedKeys.realText) as? String ?? "" }
        set { objc_setAssociatedObject(self,
                                       &AssociatedKeys.realText,
                                       newValue as NSString,
                                       .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Call this once (e.g. in viewDidLoad) to start with masking ON.
    public func enableSecureMask() {
        isSecureTextEntry = true              // shows ●●●●
        delegate          = masker            // activates masking
        addMaskToggle()                       // optional eye-button
    }

    /// Flip between masked and plain modes.
    @objc public func toggleMask() {
        isSecureTextEntry.toggle()            // UIKit redraws the field
        delegate = isSecureTextEntry ? masker : nil

        // --- keep cursor position & text intact -----------------------------
        let current = text                    // bullets or plain text right now
        text?.removeAll()
        text = isSecureTextEntry ? String(repeating: bullet, count: realText.count) : realText
        becomeFirstResponder()
    }

    // MARK: Private -----------------------------------------------------------

    private struct AssociatedKeys {
        static var masker   = "masker"
        static var realText = "realText"
    }

    /// One shared masker per field (lazily created).
    private var masker: MaskerDelegate {
        if let m = objc_getAssociatedObject(self, &AssociatedKeys.masker) as? MaskerDelegate {
            return m
        }
        let m = MaskerDelegate(owner: self)
        objc_setAssociatedObject(self, &AssociatedKeys.masker, m, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return m
    }

    /// The bullet symbol (●)
    private var bullet: String { "\u{25CF}" }

    /// Adds a right-view eye button that calls `toggleMask()`.
    private func addMaskToggle() {
        let eye = UIButton(type: .custom)
        eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eye.tintColor = .secondaryLabel
        eye.addTarget(self, action: #selector(toggleMask), for: .touchUpInside)
        rightView     = eye
        rightViewMode = .always

        // Update icon when the caller flips `isSecureTextEntry` directly
        addTarget(self, action: #selector(updateEyeIcon), for: .editingDidBegin)
    }

    @objc private func updateEyeIcon() {
        let name = isSecureTextEntry ? "eye.slash" : "eye"
        (rightView as? UIButton)?
            .setImage(UIImage(systemName: name), for: .normal)
    }
}

// MARK: - Masking delegate (private helper)
private final class MaskerDelegate: NSObject, UITextFieldDelegate {

    init(owner: UITextField) { self.owner = owner }
    private weak var owner: UITextField?
    private let bullet = "\u{25CF}"          // ●

    func textField(_ tf: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        guard let tfOwner = owner else { return false }

        // 1. Update stored real text
        if let current = tfOwner.realText as NSString? {
            tfOwner.realText = current.replacingCharacters(in: range, with: string)
        } else {
            tfOwner.realText = string
        }

        // 2. Show bullets
        tf.text = String(repeating: bullet, count: tfOwner.realText.count)

        // 3. Keep observers happy
        tf.sendActions(for: .editingChanged)

        // 4. Prevent UIKit from inserting the actual characters
        return false
    }
}

final class MyViewController: UIViewController, ShowcaseListViewControllerProtocol {

    private let passwordField = UITextField()
    private let submit        = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Configure field
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.autocorrectionType = .no
        passwordField.keyboardType = .asciiCapable
        passwordField.enableSecureMask()           // ← one-liner

        // Configure button
        submit.setTitle("Submit", for: .normal)
        submit.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)

        // Layout
        let stack = UIStackView(arrangedSubviews: [passwordField, submit])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor .constraint(equalToConstant: 260)
        ])
    }

    @objc private func handleSubmit() {
        print("Real password: \(passwordField.realText)")
    }
}
