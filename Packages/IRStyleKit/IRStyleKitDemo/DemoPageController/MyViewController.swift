//
//  MaskedTextFieldDemo.swift
//  SecureMaskDemo
//
//  Created by Omer on 13.07.2025.
//
//  A clean, self-contained example that starts with a plain UITextField and toggles
//  masking on/off through an external button while keeping an eye icon inside the
//  field.  Minimum deployment: iOS 14, UIKit-only.
//

import UIKit
import ObjectiveC.runtime

// MARK: ––––– Delegate Proxy –––––

public protocol CRTextFieldInterceptor: AnyObject, UITextFieldDelegate {}

public final class CRTextFieldDelegateProxy: NSObject, UITextFieldDelegate {
    public weak var interceptor: CRTextFieldInterceptor?
    fileprivate weak var primary: UITextFieldDelegate?

    public init(interceptor: CRTextFieldInterceptor?, primary: UITextFieldDelegate?) {
        self.interceptor = interceptor
        self.primary     = primary
        super.init()
    }

    // Dynamically report methods of both delegates
    public override func responds(to sel: Selector!) -> Bool {
        super.responds(to: sel) ||
        interceptor?.responds(to: sel) == true ||
        primary?.responds(to: sel)     == true
    }

    public override func forwardingTarget(for sel: Selector!) -> Any? {
        if interceptor?.responds(to: sel) == true { return interceptor }
        if primary?.responds(to: sel)     == true { return primary     }
        return nil
    }

    // Manually forward boolean return-value delegate calls
    public func textField(_ tf: UITextField,
                          shouldChangeCharactersIn r: NSRange,
                          replacementString s: String) -> Bool {
        let iOK = interceptor?.textField?(tf, shouldChangeCharactersIn: r, replacementString: s) ?? true
        let pOK = primary?.textField?(tf, shouldChangeCharactersIn: r, replacementString: s) ?? true
        return iOK && pOK
    }

    // Expose stored primary delegate so we can restore it
    public var primaryDelegate: UITextFieldDelegate? { primary }
}

// MARK: ––––– UITextField + Proxy helpers –––––

public extension UITextField {
    private struct Keys {
        static var proxy = "cr_proxy_key"
        static var clear = "cr_non_secure"
    }

    /// Attach masking proxy; keeps any existing delegate as “primary”.
    func attachProxy(interceptor: CRTextFieldInterceptor?,
                     primary: UITextFieldDelegate? = nil) {
        let proxy = CRTextFieldDelegateProxy(interceptor: interceptor,
                                             primary: primary ?? delegate)
        delegate = proxy
        objc_setAssociatedObject(self, &Keys.proxy, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    /// Detach proxy and restore the previously stored delegate (if any).
    func detachProxy() {
        guard let proxy = currentProxy() else { return }
        delegate = proxy.primaryDelegate
        objc_setAssociatedObject(self, &Keys.proxy, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func currentProxy() -> CRTextFieldDelegateProxy? {
        objc_getAssociatedObject(self, &Keys.proxy) as? CRTextFieldDelegateProxy
    }

    // MARK: – Stored clear-text mirror
    var nonSecureText: String {
        get { objc_getAssociatedObject(self, &Keys.clear) as? String ?? "" }
        set { objc_setAssociatedObject(self, &Keys.clear, newValue as NSString, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

// MARK: ––––– Masking Interceptor –––––

final class MaskedInterceptor: NSObject, CRTextFieldInterceptor {
    private let bullet = "\u{25CF}"
    var isMaskingEnabled = true

    func textField(_ tf: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // 1 – Update mirror clear value
        let clear = (tf.nonSecureText as NSString).replacingCharacters(in: range, with: string)
        tf.nonSecureText = clear

        // 2 – Mask-on: draw bullets manually & stop UIKit insertion
        if isMaskingEnabled {
            tf.text = String(repeating: bullet, count: clear.count)
            let cursor = range.location + string.utf16.count
            tf.setCursor(offset: cursor)
            tf.sendActions(for: .editingChanged)
            return false
        }

        // 3 – Mask-off: let UIKit handle normally
        return true
    }
}

// MARK: –––– Cursor convenience ––––

private extension UITextField {
    func setCursor(offset: Int) {
        if let pos = position(from: beginningOfDocument, offset: offset) {
            selectedTextRange = textRange(from: pos, to: pos)
        }
    }
}

// MARK: ––––– View Controller Demo –––––

final class MyViewController: UIViewController, ShowcaseListViewControllerProtocol {

    // ••• UI Elements •••
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = false        // ← starts **plain text**
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    /// External toggle button below the field
    private let secureToggleButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Enable Mask", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    /// Eye / eye.slash inside rightView
    private let eyeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "eye"), for: .normal)
        return b
    }()

    // Masking engine
    private let interceptor = MaskedInterceptor()
    private var secureObserver: NSKeyValueObservation?

    // Bullet char for local use
    private let bullet = "\u{25CF}"

    // MARK: – Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Assemble hierarchy
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        view.addSubview(passwordTextField)
        view.addSubview(secureToggleButton)

        // Layout
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            secureToggleButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            secureToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Wire actions
        secureToggleButton.addTarget(self, action: #selector(toggleSecure), for: .touchUpInside)
        eyeButton.addTarget(self, action: #selector(toggleSecure), for: .touchUpInside)

        // Observe any future changes to isSecureTextEntry (KVO is safe on iOS 14+)
        secureObserver = passwordTextField.observe(\.isSecureTextEntry, options: [.initial, .new]) { [weak self] tf, _ in
            self?.secureFlagDidChange(for: tf)
        }
    }

    // MARK: – Toggle handler

    @objc private func toggleSecure() {
        passwordTextField.isSecureTextEntry.toggle()   // KVO callback updates UI
    }

    // MARK: – Secure/plain mode dispatcher (short)

    private func secureFlagDidChange(for tf: UITextField) {
        // 1  – Capture current caret position
        let currentOffset = tf.offset(from: tf.beginningOfDocument,
                                      to: tf.selectedTextRange?.start ?? tf.endOfDocument)

        // 2  – Apply the appropriate mode
        if tf.isSecureTextEntry {
            applySecureMode(to: tf)
        } else {
            applyPlainMode(to: tf)
        }

        // 3  – Restore the caret (clamp if text is now shorter)
        restoreCaret(tf, to: currentOffset)
    }

    // MARK: – Mode helpers

    private func applySecureMode(to tf: UITextField) {
        let plain = tf.text ?? ""
        tf.nonSecureText = plain
        tf.attachProxy(interceptor: interceptor)
        interceptor.isMaskingEnabled = true
        tf.text = String(repeating: bullet, count: plain.count)

        secureToggleButton.setTitle("Disable Mask", for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }

    private func applyPlainMode(to tf: UITextField) {
        tf.detachProxy()
        interceptor.isMaskingEnabled = false
        tf.text = tf.nonSecureText

        secureToggleButton.setTitle("Enable Mask", for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
    }

    private func restoreCaret(_ tf: UITextField, to offset: Int) {
        DispatchQueue.main.async {
            let length = (tf.text ?? "").utf16.count
            let clamped = min(offset, length)
            if let pos = tf.position(from: tf.beginningOfDocument, offset: clamped) {
                tf.selectedTextRange = tf.textRange(from: pos, to: pos)
            }
        }
    }
}
