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








import UIKit
import Foundation

/// Formats a phone-number field while preserving the immutable prefix “(+<code>) ”.
/// Supports both highlighted (grouped) and non-highlighted (ungrouped) TR formatting,
/// generic 10‑digit formatting, and fully custom patterns.
public final class IRPhoneMaskedInputFieldDelegate: NSObject, UITextFieldDelegate {
    // MARK: - Public
    /// Called whenever the completion state (.empty, .incomplete, .complete) changes
    public var onCompletionStateChanged: ((IRMaskCompletionState) -> Void)?
    
    // MARK: - Private
    private var countryCode: String
    private var highlightTRGrouping: Bool
    private var customMaskPattern: String?
    private var lastCompletionState: IRMaskCompletionState = .empty
    private var prefix: String { "( +\(countryCode)) " }
    
    // MARK: - Init
    /// - Parameters:
    ///   - countryCode: the ISO country dial code (e.g., "90").
    ///   - highlightTRGrouping: when true and countryCode is "90", uses grouped TR mask (nnn nnn nn nn); when false uses ungrouped (nnnnnnnnnn).
    ///   - customMaskPattern: optional custom grouping pattern (e.g., "nn nn nn nn nn").
    ///   - onCompletionStateChanged: callback when completion state changes.
    public init(
        countryCode: String,
        highlightTRGrouping: Bool = true,
        customMaskPattern: String? = nil,
        onCompletionStateChanged: ((IRMaskCompletionState) -> Void)? = nil
    ) {
        self.countryCode = countryCode
        self.highlightTRGrouping = highlightTRGrouping
        self.customMaskPattern = customMaskPattern
        self.onCompletionStateChanged = onCompletionStateChanged
        super.init()
    }
    
    // MARK: - UITextFieldDelegate
    public func textFieldDidBeginEditing(_ tf: UITextField) {
        ensurePrefix(in: tf)
        notifyCompletionState(for: tf.text ?? "")
    }
    
    public func textField(_ tf: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard let full = tf.text else { return false }
        
        // Ensure prefix is intact
        if full.utf16.count < prefix.utf16.count {
            tf.text = prefix
            tf.setCursorPosition(offset: prefix.count)
            notifyCompletionState(for: tf.text ?? "")
            return false
        }
        
        // Extract body and digits
        let bodyStart = full.index(full.startIndex, offsetBy: prefix.count)
        var body   = String(full[bodyStart...])
        var digits = body.filter(\ .isNumber)
        
        // Block editing prefix
        if range.location < prefix.count { return false }
        
        // Determine mask and maxDigits
        let mask      = currentMask()
        let maxDigits = mask.requiredDigits
        
        // ── INSERTION LIMIT ──
        if !string.isEmpty, string.contains(where: \ .isNumber), digits.count >= maxDigits {
            return false
        }
        // ──────────────────────
        
        // Deletion handling
        if string.isEmpty {
            // Find deletion target among digits
            var delIdxInBody = range.location - prefix.count
            while delIdxInBody > 0 && !body[body.index(body.startIndex, offsetBy: delIdxInBody)].isNumber {
                delIdxInBody -= 1
            }
            let digitPositions = Self.digitPositions(in: body)
            guard let removeAt = digitPositions.firstIndex(of: delIdxInBody) else { return false }
            digits.remove(at: digits.index(digits.startIndex, offsetBy: removeAt))
            
            // Reformat
            let formatted = format(digits, with: mask)
            body = formatted.body
            tf.text = prefix + body
            
            // Position caret
            var caret = removeAt < formatted.digitPos.count ? formatted.digitPos[removeAt] : body.count
            if caret > 0, body[body.index(body.startIndex, offsetBy: caret - 1)] == " " {
                caret -= 1
            }
            tf.setCursorPosition(offset: prefix.count + caret)
            notifyCompletionState(for: tf.text ?? "")
            return false
        }
        
        // Insertion (digits only)
        let ins = string.filter(\ .isNumber)
        guard !ins.isEmpty else { return false }
        
        let caretInBody     = range.location - prefix.count
        let digitPositions  = Self.digitPositions(in: body)
        let indexInDigits   = digitPositions.filter { $0 < caretInBody }.count
        
        // Calculate allowed insertion
        let space    = max(0, maxDigits - digits.count)
        let fragment = ins.prefix(space)
        let insertPosition = digits.index(digits.startIndex, offsetBy: indexInDigits)
        digits.insert(contentsOf: fragment, at: insertPosition)
        
        // Reformat and set
        let formatted = format(digits, with: mask)
        body = formatted.body
        tf.text = prefix + body
        
        // Caret after inserted block
        let lastDigitIdx = indexInDigits + fragment.count - 1
        let caretDigit   = lastDigitIdx + 1
        let caretOffset  = caretDigit < formatted.digitPos.count ? formatted.digitPos[caretDigit] : body.count
        tf.setCursorPosition(offset: prefix.count + caretOffset)
        
        notifyCompletionState(for: tf.text ?? "")
        return false
    }
    
    // MARK: - Public helper
    /// Update country code (prefix) and reset field text
    public func updateCountryCode(to newCode: String, in textField: UITextField) {
        countryCode = newCode
        textField.text = prefix
        textField.setCursorPosition(offset: prefix.count)
        notifyCompletionState(for: textField.text ?? "")
    }
    
    /// Update just the TR grouping style (only applies when countryCode == "90")
    public func updateTRHighlightGrouping(to highlighted: Bool) {
        highlightTRGrouping = highlighted
    }
    
    /// Provide a fully custom grouping pattern (e.g., "nn nn nn nn nn")
    public func updateCustomMaskPattern(to pattern: String) {
        customMaskPattern = pattern
    }
    
    // MARK: - Private
    private func ensurePrefix(in tf: UITextField) {
        if tf.text?.hasPrefix(prefix) != true {
            tf.text = prefix
        }
        tf.setCursorPosition(offset: prefix.count)
    }
    
    private func currentMask() -> PhoneMaskPattern {
        if let custom = customMaskPattern {
            return .custom(custom)
        }
        if countryCode == "90" {
            return highlightTRGrouping ? .trGrouped : .trUngrouped
        }
        return .generic
    }
    
    private func format(_ digits: String, with mask: PhoneMaskPattern) -> (body: String, digitPos: [Int]) {
        let body = mask.definition.format(raw: digits)
            .trimmingCharacters(in: .whitespaces)
        let positions = Self.digitPositions(in: body)
        return (body, positions)
    }
    
    private static func digitPositions(in s: String) -> [Int] {
        return s.enumerated().compactMap { $0.element.isNumber ? $0.offset : nil }
    }
    
    private func notifyCompletionState(for fullText: String) {
        let bodyText = fullText.hasPrefix(prefix)
            ? String(fullText.dropFirst(prefix.count))
            : fullText
        let count    = bodyText.filter(\ .isNumber).count
        let required = currentMask().requiredDigits
        
        let state: IRMaskCompletionState = count == 0 ? .empty
            : (count < required ? .incomplete : .complete)
        if state != lastCompletionState {
            lastCompletionState = state
            onCompletionStateChanged?(state)
        }
    }
}

// MARK: - Mask enum
private enum PhoneMaskPattern {
    case trGrouped        // e.g., "nnn nnn nn nn"
    case trUngrouped      // e.g., "nnnnnnnnnn"
    case generic          // default 10-digit no-spacing
    case custom(String)   // fully custom grouping pattern
    
    var patternString: String {
        switch self {
        case .trGrouped:   return "nnn nnn nn nn"
        case .trUngrouped: return String(repeating: "n", count: 10)
        case .generic:     return String(repeating: "n", count: 10)
        case .custom(let pattern): return pattern
        }
    }
    
    var requiredDigits: Int {
        return patternString.filter { $0 == "n" }.count
    }
    
    var definition: IRMaskPatternType {
        return .custom(patternString)
    }
}

// MARK: - UITextField helper
private extension UITextField {
    func setCursorPosition(offset: Int) {
        guard let pos = position(from: beginningOfDocument, offset: offset) else { return }
        selectedTextRange = textRange(from: pos, to: pos)
    }
}
