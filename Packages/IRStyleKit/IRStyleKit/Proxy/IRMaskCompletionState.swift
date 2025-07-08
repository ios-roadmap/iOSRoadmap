//
//  IRMaskCompletionState 2.swift
//  deneme
//
//  Created by Ömer Faruk Öztürk on 8.07.2025.
//

import UIKit

//──────────────────────────────────────────────────────────────────────────────
// MARK: - Public helper types
//──────────────────────────────────────────────────────────────────────────────

/// Simple three-state completion info used by both delegates.
enum IRMaskCompletionState { case empty, incomplete, complete }

//──────────────────────────────────────────────────────────────────────────────
// MARK: - Core pattern enum  (ONE enum for every mask)
//──────────────────────────────────────────────────────────────────────────────

enum IRMaskPatternType {
    // Phone
    case phoneTRGrouped          // "nnn nnn nn nn"
    case phoneGeneric            // "nnnnnnnnnn"
    
    // Banking / finance
    case creditCardNumber        // "nnnn nnnn nnnn nnnn"
    case iban                    // "TRnn nnnn nnnn nnnn nnnn nnnn nn"
    
    // Anything else
    case custom(String)          // fully custom
    
    /// Raw pattern string (spaces and letters allowed, `'n'` = digit slot)
    var pattern: String {
        switch self {
        case .phoneTRGrouped:   return "nnn nnn nn nn"
        case .phoneGeneric:     return String(repeating: "n", count: 10)
        case .creditCardNumber: return "nnnn nnnn nnnn nnnn"
        case .iban:             return "TRnn nnnn nnnn nnnn nnnn nnnn nn"
        case .custom(let p):    return p
        }
    }
    
    /// How many digits are required for the pattern to be *complete*.
    var requiredDigits: Int { pattern.filter { $0 == "n" }.count }
    
    /// Formats a raw digits-only string into the pattern,
    /// padding empty slots with spaces so `.count` == `pattern.count`.
    func formattedDigits(from raw: String) -> String {
        let digits = raw.onlyDigits()
        var result = ""
        var di = 0
        for ch in pattern {
            if ch == "n" {
                if di < digits.count {
                    let i = digits.index(digits.startIndex, offsetBy: di)
                    result.append(digits[i])
                    di += 1
                } else {
                    result.append(" ")
                }
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

//──────────────────────────────────────────────────────────────────────────────
// MARK: - String & UITextField helpers (unchanged, but collected here)
//──────────────────────────────────────────────────────────────────────────────

private extension String {
    /// Digits only, no Unicode scalars lost.
    func onlyDigits() -> String { filter(\.isNumber) }
    
    /// Last numeric character index, or `nil`.
    func lastDigitIndex() -> Int? {
        enumerated().reversed().first(where: { $0.element.isNumber })?.offset
    }
    
    /// Positions (Int offsets) of a character inside `self`.
    func indices(for needle: Character) -> [Int] {
        enumerated().compactMap { $0.element == needle ? $0.offset : nil }
    }
}

private extension UITextField {
    /// Move cursor (caret) to `offset` (0…text.count)
    func setCursorPosition(offset: Int) {
        guard let pos = position(from: beginningOfDocument, offset: offset) else { return }
        selectedTextRange = textRange(from: pos, to: pos)
    }
}

private extension CharacterSet {
    /// No silly emojis allowed in credit-card / IBAN fields.
    static let emojiCharacters: CharacterSet = {
        var set = CharacterSet()
        set.insert(charactersIn: "\u{1F600}"..."\u{1F64F}") // common emoticons
        return set
    }()
}

private extension String {
    var containsEmoji: Bool { rangeOfCharacter(from: .emojiCharacters) != nil }
}

//──────────────────────────────────────────────────────────────────────────────
// MARK: - PHONE masked delegate
//──────────────────────────────────────────────────────────────────────────────

final class IRPhoneMaskedInputFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: Public
    var onCompletionStateChanged: ((IRMaskCompletionState) -> Void)?
    
    // MARK: Private
    private var countryCode: String
    private var customMaskPattern: String?
    private var lastCompletionState: IRMaskCompletionState = .empty
    private var prefix: String { "(+\(countryCode)) " }
    
    // Init
    init(countryCode: String,
         customMaskPattern: String? = nil,
         onCompletionStateChanged: ((IRMaskCompletionState) -> Void)? = nil) {
        self.countryCode          = countryCode
        self.customMaskPattern    = customMaskPattern
        self.onCompletionStateChanged = onCompletionStateChanged
    }
    
    //────────────────────────────────────────
    // MARK: UITextFieldDelegate
    //────────────────────────────────────────
    func textFieldDidBeginEditing(_ tf: UITextField) {
        ensurePrefix(in: tf)
        notifyCompletionState(for: tf.text ?? "")
    }
    
    func textField(_ tf: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let full = tf.text else { return false }
        
        // 1️⃣  Keep prefix immutable
        if full.utf16.count < prefix.utf16.count {
            tf.text = prefix
            tf.setCursorPosition(offset: prefix.count)
            notifyCompletionState(for: tf.text ?? "")
            return false
        }
        if range.location < prefix.count { return false }          // editing inside prefix not allowed
        
        // 2️⃣  Slice body & digits
        let bodyStart   = full.index(full.startIndex, offsetBy: prefix.count)
        var body        = String(full[bodyStart...])
        var digits      = body.filter(\.isNumber)
        
        // 3️⃣  Determine current mask
        let mask        = currentMask()
        let maxDigits   = mask.requiredDigits
        
        // 4️⃣  Overflow guard on insertion
        if !string.isEmpty,
           string.contains(where: \.isNumber),
           digits.count >= maxDigits { return false }
        
        // ────────────────────────────────────
        // Deletion branch
        // ────────────────────────────────────
        if string.isEmpty {
            var delIndexInBody = range.location - prefix.count
            // skip separators backwards
            while delIndexInBody > 0 &&
                  !body[body.index(body.startIndex, offsetBy: delIndexInBody)].isNumber {
                delIndexInBody -= 1
            }
            let digitPositions = Self.digitPositions(in: body)
            guard let removeAt = digitPositions.firstIndex(of: delIndexInBody) else { return false }
            digits.remove(at: digits.index(digits.startIndex, offsetBy: removeAt))
            
            let formatted  = format(digits, using: mask)
            body           = formatted.body
            tf.text        = prefix + body
            
            var caret = removeAt < formatted.digitPositions.count
                        ? formatted.digitPositions[removeAt]
                        : body.count
            // keep caret just before a trailing space
            if caret > 0 &&
               body[body.index(body.startIndex, offsetBy: caret - 1)] == " " { caret -= 1 }
            tf.setCursorPosition(offset: prefix.count + caret)
            
            notifyCompletionState(for: tf.text ?? "")
            return false
        }
        
        // ────────────────────────────────────
        // Insertion branch
        // ────────────────────────────────────
        let incomingDigits = string.filter(\.isNumber)
        guard !incomingDigits.isEmpty else { return false }
        
        let caretInBody     = range.location - prefix.count
        let digitPositions  = Self.digitPositions(in: body)
        let indexInDigits   = digitPositions.filter { $0 < caretInBody }.count
        
        // respect capacity
        let room            = max(0, maxDigits - digits.count)
        let fragment        = incomingDigits.prefix(room)
        let insertPos       = digits.index(digits.startIndex, offsetBy: indexInDigits)
        digits.insert(contentsOf: fragment, at: insertPos)
        
        let formatted       = format(digits, using: mask)
        body                = formatted.body
        tf.text             = prefix + body
        
        let lastDigitIdx    = indexInDigits + fragment.count - 1
        let caretDigit      = lastDigitIdx + 1
        let caretOffset     = caretDigit < formatted.digitPositions.count ?
                              formatted.digitPositions[caretDigit] : body.count
        tf.setCursorPosition(offset: prefix.count + caretOffset)
        
        notifyCompletionState(for: tf.text ?? "")
        return false
    }
    
    //────────────────────────────────────────
    // MARK: Public setters
    //────────────────────────────────────────
    func updateCountryCode(to newCode: String, in tf: UITextField) {
        countryCode = newCode
        tf.text = prefix
        tf.setCursorPosition(offset: prefix.count)
        notifyCompletionState(for: tf.text ?? "")
    }
    func updateCustomMaskPattern(to pattern: String?)    { customMaskPattern = pattern }
    
    //────────────────────────────────────────
    // MARK: Internals
    //────────────────────────────────────────
    private func ensurePrefix(in tf: UITextField) {
        if tf.text?.hasPrefix(prefix) != true { tf.text = prefix }
        tf.setCursorPosition(offset: prefix.count)
    }
    
    /// Decide at runtime which mask applies.
    private func currentMask() -> IRMaskPatternType {
        if let custom = customMaskPattern {
            return .custom(custom)
        }
        if countryCode == "90" {
            return .phoneTRGrouped
        }
        return .phoneGeneric
    }
    
    /// Format helper
    private func format(_ digits: String,
                        using mask: IRMaskPatternType)
    -> (body: String, digitPositions: [Int]) {
        let body       = mask.formattedDigits(from: digits)
                             .trimmingCharacters(in: .whitespaces)
        let positions  = Self.digitPositions(in: body)
        return (body, positions)
    }
    
    /// Int offsets of numeric chars inside `s`
    private static func digitPositions(in s: String) -> [Int] {
        s.enumerated().compactMap { $0.element.isNumber ? $0.offset : nil }
    }
    
    /// Emit `.empty` / `.incomplete` / `.complete`
    private func notifyCompletionState(for full: String) {
        let body  = full.hasPrefix(prefix) ? String(full.dropFirst(prefix.count)) : full
        let cnt   = body.filter(\.isNumber).count
        let state: IRMaskCompletionState =
            cnt == 0 ? .empty :
            (cnt < currentMask().requiredDigits ? .incomplete : .complete)
        
        if state != lastCompletionState {
            lastCompletionState = state
            onCompletionStateChanged?(state)
        }
    }
}

//──────────────────────────────────────────────────────────────────────────────
// MARK: - GENERIC masked delegate (credit card, IBAN, …)
//──────────────────────────────────────────────────────────────────────────────

final class IRMaskedInputFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: Public
    var onCompletionStateChanged: ((IRMaskCompletionState) -> Void)?
    var placeholder: String { maskDef.formattedDigits(from: "") }
    
    // MARK: Private
    private let maskDef: IRMaskPatternType
    private var lastCursorOffset = 0
    private var allowedIndexes: [Int] { maskDef.pattern.indices(for: "n") }
    
    // Init
    init(maskDefinition: IRMaskPatternType,
         onCompletionStateChanged: ((IRMaskCompletionState) -> Void)? = nil) {
        self.maskDef = maskDefinition
        self.onCompletionStateChanged = onCompletionStateChanged
    }
    
    //────────────────────────────────────────
    // MARK: UITextFieldDelegate
    //────────────────────────────────────────
    func textFieldDidBeginEditing(_ tf: UITextField) {
        // Hide caret during async repositioning for visual smoothness
        tf.tintColor = .clear
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let first = self.allowedIndexes.first {
                self.lastCursorOffset = first
                tf.setCursorPosition(offset: first)
            }
            tf.tintColor = .label
        }
    }
    
    func textField(_ tf: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let current = tf.text else { return false }
        
        // 🔙 Backspace branch
        if string.isEmpty { return handleBackspace(in: tf, range: range) }
        
        // 🛑 Reject non-digits or emojis
        guard !string.containsEmoji,
              CharacterSet.decimalDigits.isSuperset(of:
                   CharacterSet(charactersIn: string))
        else { return false }
        
        // 🛑 Already full?
        if current.onlyDigits().count >= maskDef.requiredDigits { return false }
        
        // 🔤 Normal insertion
        let updated = (current as NSString).replacingCharacters(in: range, with: string)
        tf.text = maskDef.formattedDigits(from: updated.onlyDigits())
        
        if string.count > 1 { // Paste
            lastCursorOffset = lastInsertedDigitIndex(in: tf.text ?? "")
        } else {
            updateCursorPosition(in: tf, range: range, replacementString: string)
        }
        tf.setCursorPosition(offset: lastCursorOffset)
        notifyCompletionState(text: tf.text ?? "")
        return false
    }
    
    func textFieldDidChangeSelection(_ tf: UITextField) {
        // Keep system from putting cursor into a separator
        tf.setCursorPosition(offset: lastCursorOffset)
    }
    
    //────────────────────────────────────────
    // MARK: Internals
    //────────────────────────────────────────
    private func handleBackspace(in tf: UITextField,
                                 range: NSRange) -> Bool {
        guard var txt = tf.text,
              !txt.onlyDigits().isEmpty else {
            notifyCompletionState(text: tf.text ?? "")
            return false
        }
        guard let idx = txt.lastDigitIndex() else { return false }
        
        txt.remove(at: txt.index(txt.startIndex, offsetBy: idx))
        tf.text = maskDef.formattedDigits(from: txt.onlyDigits())
        
        lastCursorOffset = min(idx, tf.text?.count ?? 0)
        tf.setCursorPosition(offset: lastCursorOffset)
        notifyCompletionState(text: tf.text ?? "")
        return false
    }
    
    private func updateCursorPosition(in tf: UITextField,
                                      range: NSRange,
                                      replacementString string: String) {
        var offset = range.location + string.count
        if string.isEmpty { // should never happen here
            while offset > 0 && !allowedIndexes.contains(offset - 1) { offset -= 1 }
        } else {            // insertion
            while offset < maskDef.pattern.count &&
                  !allowedIndexes.contains(offset) { offset += 1 }
        }
        lastCursorOffset = offset
    }
    
    private func lastInsertedDigitIndex(in txt: String) -> Int {
        for idx in allowedIndexes.filter({ $0 < txt.count }).reversed()
        where txt[txt.index(txt.startIndex, offsetBy: idx)].isNumber {
            return idx + 1
        }
        return allowedIndexes.first ?? txt.count
    }
    
    private func notifyCompletionState(text: String) {
        let digits   = text.onlyDigits().count
        let required = maskDef.requiredDigits
        let state: IRMaskCompletionState =
            digits == 0 ? .empty :
            (digits < required ? .incomplete : .complete)
        onCompletionStateChanged?(state)
    }
}

//
//  ViewController.swift
//  deneme
//
//  Created by Ömer Faruk Öztürk on 13.06.2025.
//

import UIKit

import UIKit

final class ViewController: UIViewController {
    // MARK: - UI Elements
    private let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        return tf
    }()

    private let creditCardTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        return tf
    }()

    private let randomCodeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Random Country Code", for: .normal)
        return btn
    }()

    // MARK: - Mask Delegates
    private lazy var phoneMaskDelegate = IRPhoneMaskedInputFieldDelegate(
        countryCode: "90",
        onCompletionStateChanged: { state in
            // handle completion state if needed
        }
    )

    private lazy var creditMaskDelegate = IRMaskedInputFieldDelegate(
        maskDefinition: .custom("nnnn nn** **** nnnn"),
        onCompletionStateChanged: { state in
            // handle completion state if needed
        }
    )

    // Available country codes
    private let countryCodes = ["1", "44", "49", "61", "81", "90", "33", "7"]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        configureDelegates()
    }

    // MARK: - Setup
    private func setupSubviews() {
        [phoneTextField, creditCardTextField, randomCodeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        creditCardTextField.placeholder = creditMaskDelegate.placeholder
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Phone TextField
            phoneTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),

            // Random Button
            randomCodeButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            randomCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Credit Card TextField
            creditCardTextField.topAnchor.constraint(equalTo: randomCodeButton.bottomAnchor, constant: 40),
            creditCardTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            creditCardTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            creditCardTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configureDelegates() {
        phoneTextField.delegate = phoneMaskDelegate
        creditCardTextField.delegate = creditMaskDelegate
        randomCodeButton.addTarget(self, action: #selector(randomCodeTapped), for: .touchUpInside)

        // Initialize phone field with prefix
        phoneMaskDelegate.updateCountryCode(to: "90", in: phoneTextField)
    }

    // MARK: - Actions
    @objc private func randomCodeTapped() {
        let newCode = countryCodes.randomElement() ?? "90"
        phoneMaskDelegate.updateCountryCode(to: newCode, in: phoneTextField)
        randomCodeButton.setTitle("Code: +\(newCode)", for: .normal)
    }
}
