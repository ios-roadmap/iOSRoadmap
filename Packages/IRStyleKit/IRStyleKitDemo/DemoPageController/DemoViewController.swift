//
//  IRMaskedDemoPageController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 2.07.2025.
//


import UIKit
import IRStyleKit
import IRCore

final class IRMaskedDemoPageController: UIViewController, ShowcaseListViewControllerProtocol {
    // MARK: - UI
    private let cardTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.font = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        return tf
    }()
    
    private let phoneTextField = UITextField()
    private let maskDelegate = IRPhoneMaskedInputFieldDelegate(countryCode: "90") { result in
        print(result)
    }  // or any other code


    // MARK: - Mask Delegate
    private var maskedDelegate: IRMaskedInputFieldDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMaskDelegate()
    }

    // MARK: - Setup Helpers
    private func configureUI() {
        // Configure text field
               phoneTextField.borderStyle = .roundedRect
               phoneTextField.keyboardType = .numberPad
               phoneTextField.placeholder = "Enter phone number"
               phoneTextField.delegate = maskDelegate
               
               // Add & layout
               phoneTextField.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(phoneTextField)
               NSLayoutConstraint.activate([
                   phoneTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                   phoneTextField.heightAnchor.constraint(equalToConstant: 44)
               ])
        
        
        title = "Masked Input Demo"
        view.backgroundColor = .systemBackground
//        view.addSubview(cardTextField)
//
//        NSLayoutConstraint.activate([
//            cardTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            cardTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
//            cardTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
//            cardTextField.heightAnchor.constraint(equalToConstant: 50)
//        ])
    }

    private func configureMaskDelegate() {
        // Define the custom mask pattern
        let maskDefinition = IRMaskDefinition(patternType: .custom("nnnn nn** **** nnnn"))

        // Initialise the delegate with a completion‑state callback
        maskedDelegate = IRMaskedInputFieldDelegate(
            formatter: .generic,
            maskDefinition: maskDefinition,
            onCompletionStateChanged: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .complete:
                    self.cardTextField.layer.borderColor = UIColor.systemGreen.cgColor
                    self.cardTextField.layer.borderWidth = 1
                case .incomplete:
                    self.cardTextField.layer.borderColor = UIColor.systemYellow.cgColor
                    self.cardTextField.layer.borderWidth = 1
                case .empty:
                    self.cardTextField.layer.borderWidth = 0
                }
            }
        )

        cardTextField.delegate = maskedDelegate
        cardTextField.placeholder = maskedDelegate?.placeholder
    }
}




//
//  IRPhoneMaskedInputFieldDelegate.swift
//  IRViews
//
//  Created: 08.07.2025  —  Polished: 10.07.2025
//

import UIKit

/// Formats a phone-number field while preserving the immutable prefix
/// “(+<code>) ”.
/// • TR (“90”) ⇒ 3-3-2-2 grouping, no trailing blanks
/// • Others ⇒ plain 10-digit limit
/// Caret behaviour:
/// • Drag caret anywhere → insert/delete works in-place
/// • Backspacing on a separator deletes the digit to its left
/// • After delete, if caret lands on a space it is auto-nudged one char left
public final class IRPhoneMaskedInputFieldDelegate: NSObject, UITextFieldDelegate {

    // MARK: – Public
    
    /// Notifies when the digit count is empty / incomplete / complete.
    public var onCompletionStateChanged: ((IRMaskCompletionState) -> Void)?

    // MARK: – Private
    
    private var countryCode: String {
        didSet {
            // Ensure prefix updates when countryCode changes
            // Reset text if needed
        }
    }

    /// Computed prefix based on current country code
    private var prefix: String { "(+\(countryCode)) " }

    // MARK: – Init
    
    public init(countryCode: String,
                onCompletionStateChanged: ((IRMaskCompletionState) -> Void)? = nil) {
        self.countryCode = countryCode
        self.onCompletionStateChanged = onCompletionStateChanged
        super.init()
    }

    // MARK: – UITextFieldDelegate
    
    public func textFieldDidBeginEditing(_ tf: UITextField) {
        // Ensure prefix
        if tf.text?.hasPrefix(prefix) == false {
            tf.text = prefix
        }
        tf.setCursorPosition(offset: prefix.count)
        notifyCompletionState(for: tf.text ?? "")
    }

    public func textField(_ tf: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {

        guard let full = tf.text else { return false }
        // Prevent crashes when text shorter than prefix
        guard full.utf16.count >= prefix.utf16.count else {
            tf.text = prefix
            tf.setCursorPosition(offset: prefix.count)
            notifyCompletionState(for: tf.text ?? "")
            return false
        }

        // Extract body safely
        let bodyStart = full.index(full.startIndex, offsetBy: prefix.count)
        var body = String(full[bodyStart...])
        var digits = body.filter(\.isNumber)

        // Block edits inside prefix
        if range.location < prefix.count {
            return false
        }

        // DELETE
        if string.isEmpty {
            var delBodyIdx = range.location - prefix.count
            while delBodyIdx > 0 && !body[body.index(body.startIndex, offsetBy: delBodyIdx)].isNumber {
                delBodyIdx -= 1
            }
            let digitPos = Self.digitPositions(in: body)
            guard let delDigitIdx = digitPos.firstIndex(of: delBodyIdx) else {
                return false
            }
            let rmIndex = digits.index(digits.startIndex, offsetBy: delDigitIdx)
            digits.remove(at: rmIndex)

            let formatted = format(digits)
            body = formatted.body
            tf.text = prefix + body

            var caretOffset = delDigitIdx < formatted.digitPos.count
                ? formatted.digitPos[delDigitIdx]
                : body.count
            if caretOffset > 0,
               body[body.index(body.startIndex, offsetBy: caretOffset - 1)] == " " {
                caretOffset -= 1
            }
            tf.setCursorPosition(offset: prefix.count + caretOffset)
            notifyCompletionState(for: tf.text ?? "")
            return false
        }

        // INSERT (digits only)
        let ins = string.filter(\.isNumber)
        guard !ins.isEmpty else { return false }

        let caretInBody = range.location - prefix.count
        let digitPos = Self.digitPositions(in: body)
        let idxInDigits = digitPos.filter { $0 < caretInBody }.count

        let room = max(0, 10 - digits.count)
        let fragment = ins.prefix(room)
        let insPt = digits.index(digits.startIndex, offsetBy: idxInDigits)
        digits.insert(contentsOf: fragment, at: insPt)

        let formatted = format(digits)
        body = formatted.body
        tf.text = prefix + body

        let lastIdx = idxInDigits + fragment.count - 1
        let caretDig = lastIdx + 1
        let caretOff = caretDig < formatted.digitPos.count
            ? formatted.digitPos[caretDig]
            : body.count
        tf.setCursorPosition(offset: prefix.count + caretOff)

        notifyCompletionState(for: tf.text ?? "")
        return false
    }

    // MARK: – Private helpers

    private func format(_ digits: String) -> (body: String, digitPos: [Int]) {
        countryCode == "90" ? Self.formatTR(digits) : (digits, Array(0..<digits.count))
    }

    private static func formatTR(_ d: String) -> (String, [Int]) {
        var out = "", pos: [Int] = []
        var cur = 0
        for (i, ch) in d.enumerated() {
            if i == 3 || i == 6 || i == 8 {
                out.append(" ")
                cur += 1
            }
            out.append(ch)
            pos.append(cur)
            cur += 1
        }
        return (out, pos)
    }

    private static func digitPositions(in s: String) -> [Int] {
        s.enumerated().compactMap { $0.element.isNumber ? $0.offset : nil }
    }

    private func notifyCompletionState(for fullText: String) {
        let bodyText: String
        if fullText.hasPrefix(prefix) {
            bodyText = String(fullText.dropFirst(prefix.count))
        } else {
            bodyText = fullText
        }
        let digitCount = bodyText.filter(\.isNumber).count
        let required = 10
        let state: IRMaskCompletionState
        switch digitCount {
        case 0:
            state = .empty
        case 1..<required:
            state = .incomplete
        default:
            state = .complete
        }
        onCompletionStateChanged?(state)
    }
}


// Mini helpers

private extension String {
    var digitsOnly: String { filter(\.isNumber) }
}

private extension UITextField {
    func setCursorPosition(offset: Int) {
        guard let p = position(from: beginningOfDocument, offset: offset) else { return }
        selectedTextRange = textRange(from: p, to: p)
    }
}
