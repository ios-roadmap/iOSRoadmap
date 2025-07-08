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
       private let maskDelegate = IRPhoneMaskedInputFieldDelegate(countryCode: "90")  // or any other code


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

/// Formats a phone‐number field while preserving the immutable prefix
/// “(+<code>) ”.
/// • **TR (“90”)** ⇒ 3-3-2-2 grouping, no trailing blanks
/// • **Others**     ⇒ plain 10-digit limit
/// Caret behaviour:
/// • Drag caret anywhere → insert / delete works in-place
/// • Backspacing on a separator deletes the digit to its left
/// • After delete, if caret lands on a space it is auto-nudged one char left
public final class IRPhoneMaskedInputFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: – Init
    
    public init(countryCode: String) {
        self.countryCode = countryCode
        self.prefix      = "(+\(countryCode)) "
        super.init()
    }
    
    // MARK: – UITextFieldDelegate
    
    public func textFieldDidBeginEditing(_ tf: UITextField) {
        if tf.text?.hasPrefix(prefix) == false { tf.text = prefix }
        tf.setCursorPosition(offset: prefix.count)
    }
    
    public func textField(_ tf: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        
        guard let full = tf.text else { return false }
        let bodyRange  = NSRange(location: prefix.count,
                                 length: full.utf16.count - prefix.count)
        var body   = (full as NSString).substring(with: bodyRange)
        var digits = body.digitsOnly
        
        // Block edits inside prefix
        if range.location < prefix.count { return false }
        
        // --------------------------------------------------------------------
        // DELETE
        // --------------------------------------------------------------------
        if string.isEmpty {
            // Absolute pos **in body** where ⌫ acts
            var delBodyIdx = range.location - prefix.count
            
            // If on space, walk left to nearest digit
            while delBodyIdx > 0,
                  !body[body.index(body.startIndex, offsetBy: delBodyIdx)].isNumber {
                delBodyIdx -= 1
            }
            // Which digit is that?
            let digitPos = Self.digitPositions(in: body)
            guard let delDigitIdx = digitPos.firstIndex(of: delBodyIdx) else { return false }
            
            // Remove digit
            let rm = digits.index(digits.startIndex, offsetBy: delDigitIdx)
            digits.remove(at: rm)
            
            // Reformat
            let formatted = format(digits)
            body = formatted.body
            tf.text = prefix + body
            
            // Caret: before the digit that slid left
            var caretOffset = (delDigitIdx < formatted.digitPos.count)
                ? formatted.digitPos[delDigitIdx]
                : body.count
            
            // ---- NEW: if caret sits on space, pull it one step left
            if caretOffset > 0 &&
               body[body.index(body.startIndex, offsetBy: caretOffset - 1)] == " " {
                caretOffset -= 1
            }
            // ----
            
            tf.setCursorPosition(offset: prefix.count + caretOffset)
            return false
        }
        
        // --------------------------------------------------------------------
        // INSERT ­(digits only)
        // --------------------------------------------------------------------
        let ins = string.digitsOnly
        guard !ins.isEmpty else { return false }
        
        let caretInBody = range.location - prefix.count
        let digitPos    = Self.digitPositions(in: body)
        let idxInDigits = digitPos.filter { $0 < caretInBody }.count
        
        // Cap at 10
        let room = max(0, 10 - digits.count)
        let fragment = ins.prefix(room)
        let insPt = digits.index(digits.startIndex, offsetBy: idxInDigits)
        digits.insert(contentsOf: fragment, at: insPt)
        
        let formatted = format(digits)
        body = formatted.body
        tf.text = prefix + body
        
        // Caret after last inserted digit
        let lastIdx   = idxInDigits + fragment.count - 1
        let caretDig  = lastIdx + 1
        let caretOff  = (caretDig < formatted.digitPos.count)
            ? formatted.digitPos[caretDig]
            : body.count
        tf.setCursorPosition(offset: prefix.count + caretOff)
        return false
    }
    
    // MARK: – Private helpers
    
    private let countryCode: String
    private let prefix:      String
    
    private func format(_ digits: String) -> (body: String, digitPos: [Int]) {
        countryCode == "90" ? Self.formatTR(digits) : (digits, Array(0..<digits.count))
    }
    
    private static func formatTR(_ d: String) -> (String, [Int]) {
        var out = "", pos: [Int] = []; var cur = 0
        for (i,ch) in d.enumerated() {
            if i == 3 || i == 6 || i == 8 { out.append(" "); cur += 1 }
            out.append(ch); pos.append(cur); cur += 1
        }
        return (out, pos)
    }
    
    private static func digitPositions(in s: String) -> [Int] {
        s.enumerated().compactMap { $0.element.isNumber ? $0.offset : nil }
    }
}


// MARK: – Mini helpers

private extension String {
    var digitsOnly: String { filter(\.isNumber) }
}

private extension UITextField {
    func setCursorPosition(offset: Int) {
        guard let p = position(from: beginningOfDocument, offset: offset) else { return }
        selectedTextRange = textRange(from: p, to: p)
    }
}
