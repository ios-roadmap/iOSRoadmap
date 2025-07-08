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
    private let phoneTextField = UITextField()
    private let randomButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Random Country", for: .normal)
        return btn
    }()
    
    // your existing mask delegate, start with "90"
    private let maskDelegate = IRPhoneMaskedInputFieldDelegate(countryCode: "90") { result in
        print(result)
    }

    // list of some country codes you want to support
    private let countryCodes = ["1", "44", "49", "33", "81", "90", "61", "91", "86", "7"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMaskDelegate()
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Masked Input Demo"

        // phoneTextField
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.keyboardType = .numberPad
        phoneTextField.placeholder = "Enter phone number"
        phoneTextField.delegate = maskDelegate
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneTextField)

        // randomButton
        randomButton.addTarget(self, action: #selector(didTapRandom), for: .touchUpInside)
        view.addSubview(randomButton)

        NSLayoutConstraint.activate([
            phoneTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),

            randomButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureMaskDelegate() {
        // already set as delegate in configureUI()
        // no changes needed here
    }

    @objc private func didTapRandom() {
        // pick a random code
        let newCode = countryCodes.randomElement()!
        // update mask
        maskDelegate.updateCountryCode(to: newCode, in: phoneTextField)
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

    private var countryCode: String

    /// Always updated prefix based on current country code
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
        ensurePrefix(in: tf)
        notifyCompletionState(for: tf.text ?? "")
    }

    public func textField(_ tf: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard let full = tf.text else { return false }

        // Ensure prefix always present
        guard full.utf16.count >= prefix.utf16.count else {
            tf.text = prefix
            tf.setCursorPosition(offset: prefix.count)
            notifyCompletionState(for: tf.text ?? "")
            return false
        }

        // Extract body safely
        let bodyStartIdx = full.index(full.startIndex, offsetBy: prefix.count)
        var body = String(full[bodyStartIdx...])
        var digits = body.filter(\.isNumber)

        // Block edits inside prefix
        if range.location < prefix.count { return false }

        // DELETE
        if string.isEmpty {
            var delBodyIdx = range.location - prefix.count
            while delBodyIdx > 0 && !body[body.index(body.startIndex, offsetBy: delBodyIdx)].isNumber {
                delBodyIdx -= 1
            }
            let digitPositions = Self.digitPositions(in: body)
            guard let delDigitIdx = digitPositions.firstIndex(of: delBodyIdx) else {
                return false
            }
            digits.remove(at: digits.index(digits.startIndex, offsetBy: delDigitIdx))

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
        let digitPositions = Self.digitPositions(in: body)
        let idxInDigits = digitPositions.filter { $0 < caretInBody }.count

        // Cap at 10 digits
        let space = max(0, 10 - digits.count)
        let fragment = ins.prefix(space)
        let insertIdx = digits.index(digits.startIndex, offsetBy: idxInDigits)
        digits.insert(contentsOf: fragment, at: insertIdx)

        let formatted = format(digits)
        body = formatted.body
        tf.text = prefix + body

        let lastDigitIdx = idxInDigits + fragment.count - 1
        let caretDigit = lastDigitIdx + 1
        let caretOffset = caretDigit < formatted.digitPos.count
            ? formatted.digitPos[caretDigit]
            : body.count
        tf.setCursorPosition(offset: prefix.count + caretOffset)

        notifyCompletionState(for: tf.text ?? "")
        return false
    }

    // MARK: – Public helper

    /// Call when the country code changes to reapply mask and prefix.
    public func updateCountryCode(to newCode: String, in textField: UITextField) {
        // 1) Update the countryCode property
        self.countryCode = newCode

        // 2) Set the text to the new prefix only
        textField.text = prefix

        // 3) Move the caret to the end of the prefix
        textField.setCursorPosition(offset: prefix.count)

        // 4) Notify about empty/incomplete state
        notifyCompletionState(for: textField.text ?? "")
    }



    // MARK: – Private helpers

    private func ensurePrefix(in tf: UITextField) {
        if tf.text?.hasPrefix(prefix) != true {
            tf.text = prefix
        }
        tf.setCursorPosition(offset: prefix.count)
    }

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
        let bodyText: String = fullText.hasPrefix(prefix)
            ? String(fullText.dropFirst(prefix.count))
            : fullText
        let digitCount = bodyText.filter(\.isNumber).count
        let required = 10
        let state: IRMaskCompletionState
        switch digitCount {
        case 0:                   state = .empty
        case 1..<required:        state = .incomplete
        default:                  state = .complete
        }
        onCompletionStateChanged?(state)
    }
}

// Mini helpers

private extension UITextField {
    func setCursorPosition(offset: Int) {
        guard let p = position(from: beginningOfDocument, offset: offset) else { return }
        selectedTextRange = textRange(from: p, to: p)
    }
}
