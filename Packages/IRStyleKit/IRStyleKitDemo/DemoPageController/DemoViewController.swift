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
//  Created: 08.07.2025 — Updated: 10.07.2025
//

import UIKit
import Foundation

/// Formats a phone-number field while preserving the immutable prefix “(+<code>) ”.
/// • TR (“90”) → mask `nnn nnn nn nn`   → 10 hane
/// • Diğer     → mask `nnnnnnnnnn`       → 10 hane
/// Caret davranışı: ekle/sil, ayırıcı üstünde backspace vb.
public final class IRPhoneMaskedInputFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: Public
    
    public var onCompletionStateChanged: ((IRMaskCompletionState) -> Void)?
    
    // MARK: Private
    
    private var countryCode: String
    private var lastCompletionState: IRMaskCompletionState = .empty   // spam koruması
    private var prefix: String { "(+\(countryCode)) " }
    
    // MARK: Init
    
    public init(countryCode: String,
                onCompletionStateChanged: ((IRMaskCompletionState) -> Void)? = nil) {
        self.countryCode = countryCode
        self.onCompletionStateChanged = onCompletionStateChanged
        super.init()
    }
    
    // MARK: UITextFieldDelegate
    
    public func textFieldDidBeginEditing(_ tf: UITextField) {
        ensurePrefix(in: tf)
        notifyCompletionState(for: tf.text ?? "")
    }
    
    public func textField(_ tf: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard let full = tf.text else { return false }
        
        // Prefix bozulmasın
        guard full.utf16.count >= prefix.utf16.count else {
            tf.text = prefix
            tf.setCursorPosition(offset: prefix.count)
            notifyCompletionState(for: tf.text ?? "")
            return false
        }
        
        // Body + dijit dizisi
        let bodyStart = full.index(full.startIndex, offsetBy: prefix.count)
        var body   = String(full[bodyStart...])
        var digits = body.filter(\.isNumber)
        
        // Prefix içinde düzenlemeyi engelle
        if range.location < prefix.count { return false }
        
        // Maskeye göre maksimum hane
        let mask      = currentMask()
        let maxDigits = mask.requiredDigits
        
        // ── EKLEME BLOĞU KISITI ──
        if !string.isEmpty, string.contains(where: \.isNumber), digits.count >= maxDigits {
            return false
        }
        // ─────────────────────────
        
        // DELETE
        if string.isEmpty {
            var delBodyIdx = range.location - prefix.count
            while delBodyIdx > 0 &&
                  !body[body.index(body.startIndex, offsetBy: delBodyIdx)].isNumber {
                delBodyIdx -= 1
            }
            let digitPositions = Self.digitPositions(in: body)
            guard let delDigitIdx = digitPositions.firstIndex(of: delBodyIdx) else { return false }
            digits.remove(at: digits.index(digits.startIndex, offsetBy: delDigitIdx))
            
            let formatted = format(digits)
            body = formatted.body
            tf.text = prefix + body
            
            var caret = delDigitIdx < formatted.digitPos.count
                ? formatted.digitPos[delDigitIdx]
                : body.count
            if caret > 0,
               body[body.index(body.startIndex, offsetBy: caret - 1)] == " " {
                caret -= 1
            }
            tf.setCursorPosition(offset: prefix.count + caret)
            notifyCompletionState(for: tf.text ?? "")
            return false
        }
        
        // INSERT (yalnızca rakam)
        let ins = string.filter(\.isNumber)
        guard !ins.isEmpty else { return false }
        
        let caretInBody   = range.location - prefix.count
        let digitPositions = Self.digitPositions(in: body)
        let idxInDigits    = digitPositions.filter { $0 < caretInBody }.count
        
        // Kalan boşluk
        let space    = max(0, maxDigits - digits.count)
        let fragment = ins.prefix(space)
        let insertIdx = digits.index(digits.startIndex, offsetBy: idxInDigits)
        digits.insert(contentsOf: fragment, at: insertIdx)
        
        let formatted = format(digits)
        body = formatted.body
        tf.text = prefix + body
        
        let lastDigitIdx = idxInDigits + fragment.count - 1
        let caretDigit   = lastDigitIdx + 1
        let caretOffset  = caretDigit < formatted.digitPos.count
            ? formatted.digitPos[caretDigit]
            : body.count
        tf.setCursorPosition(offset: prefix.count + caretOffset)
        
        notifyCompletionState(for: tf.text ?? "")
        return false
    }
    
    // MARK: Public helper
    
    public func updateCountryCode(to newCode: String, in textField: UITextField) {
        countryCode = newCode
        textField.text = prefix
        textField.setCursorPosition(offset: prefix.count)
        notifyCompletionState(for: textField.text ?? "")
    }
    
    // MARK: Private helpers
    
    private func ensurePrefix(in tf: UITextField) {
        if tf.text?.hasPrefix(prefix) != true {
            tf.text = prefix
        }
        tf.setCursorPosition(offset: prefix.count)
    }
    
    private func currentMask() -> PhoneMaskPattern {
        countryCode == "90" ? .tr : .generic
    }
    
    private func format(_ digits: String) -> (body: String, digitPos: [Int]) {
        let mask = currentMask()
        let formatter = IRMaskFormatterType.generic.instance
        var body = formatter.format(text: digits, with: mask.definition)
        
        // Sondaki boşlukları temizle
        while body.last == " " { body.removeLast() }
        
        let positions = Self.digitPositions(in: body)
        return (body, positions)
    }
    
    private static func digitPositions(in s: String) -> [Int] {
        s.enumerated().compactMap { $0.element.isNumber ? $0.offset : nil }
    }
    
    private func notifyCompletionState(for fullText: String) {
        let bodyText = fullText.hasPrefix(prefix)
            ? String(fullText.dropFirst(prefix.count))
            : fullText
        let digitCount = bodyText.filter(\.isNumber).count
        let required   = currentMask().requiredDigits
        
        let state: IRMaskCompletionState
        switch digitCount {
        case 0:            state = .empty
        case 1..<required: state = .incomplete
        default:           state = .complete
        }
        
        if state != lastCompletionState {
            lastCompletionState = state
            onCompletionStateChanged?(state)
        }
    }
}

// MARK: UITextField helper

private extension UITextField {
    func setCursorPosition(offset: Int) {
        guard let p = position(from: beginningOfDocument, offset: offset) else { return }
        selectedTextRange = textRange(from: p, to: p)
    }
}

// MARK: Mask enum

private enum PhoneMaskPattern {
    case tr
    case generic
    
    /// Örn. "nnn nnn nn nn"
    var patternString: String {
        switch self {
        case .tr:      "nnn nnn nn nn"
        case .generic: "nnnnnnnnnn"
        }
    }
    
    /// Kaç “n” varsa o kadar hane gerekir
    var requiredDigits: Int {
        patternString.filter { $0 == "n" }.count
    }
    
    /// IRMaskDefinition’e dönüştür
    var definition: IRMaskDefinition {
        IRMaskDefinition(patternType: .custom(patternString))
    }
}
