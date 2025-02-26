import UIKit

// MARK: - Mask Definition

/// Represents the configuration for a text mask.
/// - Parameters:
///   - pattern: The pattern used for formatting (e.g., "---- --** **** ----").
///   - emptyCharacter: The character to display when input is missing.
///   - disabledCharacter: The character that represents fixed sections.
///   - editablePlaceholder: The placeholder indicating an editable section.
struct MaskDefinition {
    let pattern: String
    let emptyCharacter: Character
    let disabledCharacter: Character
    let editablePlaceholder: Character

    /// Initializes a new MaskDefinition.
    /// - Parameters:
    ///   - pattern: The format pattern.
    ///   - emptyCharacter: Character shown when no input is present.
    ///   - disabledCharacter: Character for fixed (non-editable) positions.
    ///   - editablePlaceholder: Placeholder for editable positions (default is "-").
    init(pattern: String,
         emptyCharacter: Character,
         disabledCharacter: Character,
         editablePlaceholder: Character = "-") {
        self.pattern = pattern
        self.emptyCharacter = emptyCharacter
        self.disabledCharacter = disabledCharacter
        self.editablePlaceholder = editablePlaceholder
    }
}

// MARK: - Mask Formatter Protocol

/// Protocol defining methods for formatting text based on a mask.
protocol MaskFormatter {
    /// Formats the input text according to the specified mask definition.
    /// - Parameters:
    ///   - text: The raw text input.
    ///   - definition: The mask definition to apply.
    /// - Returns: A formatted string.
    func format(text: String, with definition: MaskDefinition) -> String
    
    /// Returns the indices within the pattern that are editable.
    /// - Parameters:
    ///   - pattern: The mask pattern.
    ///   - editablePlaceholder: The character representing editable positions.
    /// - Returns: An array of editable index positions.
    func allowedInputIndexes(for pattern: String, editablePlaceholder: Character) -> [Int]
}

// MARK: - Generic Mask Formatter

/// A generic implementation of the MaskFormatter protocol.
class GenericMaskFormatter: MaskFormatter {
    /// Formats the given text based on the provided mask definition.
    func format(text: String, with definition: MaskDefinition) -> String {
        let cleanDigits = text.filter { $0.isNumber }
        var formattedText = ""
        var digitIndex = 0
        
        for maskChar in definition.pattern {
            if maskChar == definition.editablePlaceholder {
                if digitIndex < cleanDigits.count {
                    let index = cleanDigits.index(cleanDigits.startIndex, offsetBy: digitIndex)
                    formattedText.append(cleanDigits[index])
                    digitIndex += 1
                } else {
                    formattedText.append(definition.emptyCharacter)
                }
            } else if maskChar == definition.disabledCharacter {
                formattedText.append(definition.disabledCharacter)
            } else {
                formattedText.append(maskChar)
            }
        }
        return formattedText
    }
    
    /// Returns an array of indices that are marked as editable in the pattern.
    func allowedInputIndexes(for pattern: String, editablePlaceholder: Character) -> [Int] {
        pattern.enumerated().compactMap { $1 == editablePlaceholder ? $0 : nil }
    }
}

// MARK: - UITextField Extension (Cursor Positioning)

extension UITextField {
    /// Sets the cursor position at the specified offset.
    /// - Parameter offset: The offset from the beginning of the document.
    func setCursorPosition(offset: Int) {
        guard let pos = position(from: beginningOfDocument, offset: offset) else { return }
        selectedTextRange = textRange(from: pos, to: pos)
    }
}

// MARK: - String Extension (Digit Utilities)

extension String {
    /// A computed property that returns a string containing only the digits.
    var digits: String {
        filter { $0.isNumber }
    }
    
    /// Finds the index of the last digit in the string.
    /// - Returns: The index of the last digit, or nil if no digit is found.
    func lastDigitIndex() -> Int? {
        for i in stride(from: count - 1, through: 0, by: -1) {
            let idx = index(startIndex, offsetBy: i)
            if self[idx].isNumber {
                return i
            }
        }
        return nil
    }
}

// MARK: - MaskedTextFieldDelegate

/// A UITextFieldDelegate that applies a mask formatter to user input.
class MaskedTextFieldDelegate: NSObject, UITextFieldDelegate {
    private let formatter: MaskFormatter
    private let maskDefinition: MaskDefinition
    private var lastCursorOffset: Int = 0
    
    /// Initializes a new MaskedTextFieldDelegate.
    /// - Parameters:
    ///   - formatter: An instance conforming to MaskFormatter.
    ///   - maskDefinition: The mask definition to use.
    init(formatter: MaskFormatter, maskDefinition: MaskDefinition) {
        self.formatter = formatter
        self.maskDefinition = maskDefinition
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    /// Called when text field editing begins. Positions the cursor at the first editable index.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = .clear
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let allowedIndexes = self.formatter.allowedInputIndexes(
                for: self.maskDefinition.pattern,
                editablePlaceholder: self.maskDefinition.editablePlaceholder
            )
            if let firstIndex = allowedIndexes.first {
                textField.setCursorPosition(offset: firstIndex)
            }
            textField.tintColor = .label
        }
    }
    
    /// Handles character changes in the text field, enforcing mask rules.
    /// - Parameters:
    ///   - textField: The UITextField being edited.
    ///   - range: The range of characters to be replaced.
    ///   - string: The replacement string.
    /// - Returns: A Boolean value indicating whether the change should be made.
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        
        if string.isEmpty {
            return handleBackspace(in: textField, range: range)
        }
        
        // Allow only numeric input.
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        let cleanDigits = currentText.digits
        let maxDigits = maskDefinition.pattern.filter { $0 == maskDefinition.editablePlaceholder }.count
        if cleanDigits.count >= maxDigits { return false }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        textField.text = formatter.format(text: updatedText, with: maskDefinition)
        updateCursorPosition(in: textField, range: range, replacementString: string)
        textField.setCursorPosition(offset: lastCursorOffset)
        
        return false
    }
    
    /// Ensures the cursor remains at the correct position after selection changes.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.setCursorPosition(offset: lastCursorOffset)
    }
}

// MARK: - MaskedTextFieldDelegate Helpers

private extension MaskedTextFieldDelegate {
    /// Handles the backspace (deletion) action in the text field.
    /// - Parameters:
    ///   - textField: The UITextField being edited.
    ///   - range: The range of characters to be removed.
    /// - Returns: A Boolean value indicating whether the change should be made.
    func handleBackspace(in textField: UITextField, range: NSRange) -> Bool {
        guard var text = textField.text, !text.digits.isEmpty else { return false }
        guard let indexToRemove = text.lastDigitIndex() else { return false }
        
        text.remove(at: text.index(text.startIndex, offsetBy: indexToRemove))
        textField.text = formatter.format(text: text, with: maskDefinition)
        lastCursorOffset = min(indexToRemove, textField.text?.count ?? 0)
        textField.setCursorPosition(offset: lastCursorOffset)
        return false
    }
    
    /// Updates the cursor position to the next valid editable index.
    /// - Parameters:
    ///   - textField: The UITextField being edited.
    ///   - range: The range of the current change.
    ///   - string: The replacement string.
    func updateCursorPosition(in textField: UITextField,
                              range: NSRange,
                              replacementString string: String) {
        let pattern = maskDefinition.pattern
        let allowedIndexes = formatter.allowedInputIndexes(
            for: pattern,
            editablePlaceholder: maskDefinition.editablePlaceholder
        )
        var newOffset = range.location + string.count
        
        if string.isEmpty {
            // For deletion, move left until an editable index is found.
            while newOffset > 0 {
                if allowedIndexes.contains(newOffset - 1) { break }
                newOffset -= 1
            }
        } else {
            // For insertion, move right until an editable index is found.
            while newOffset < pattern.count {
                if allowedIndexes.contains(newOffset) { break }
                newOffset += 1
            }
        }
        lastCursorOffset = newOffset
    }
}

// MARK: - Example ViewController

/// A view controller demonstrating the use of MaskedTextFieldDelegate.
class ViewController: UIViewController {
    private let maskDefinition = MaskDefinition(
        pattern: "---- --** **** ----",
        emptyCharacter: " ",
        disabledCharacter: "*",
        editablePlaceholder: "-"
    )
    
    private let formatter: MaskFormatter = GenericMaskFormatter()
    
    private lazy var maskedDelegate: MaskedTextFieldDelegate = {
        MaskedTextFieldDelegate(formatter: formatter, maskDefinition: maskDefinition)
    }()
    
    /// Configures the view and adds a masked text field.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let cardTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        cardTextField.borderStyle = .roundedRect
        cardTextField.keyboardType = .numberPad
        cardTextField.text = formatter.format(text: "", with: maskDefinition)
        cardTextField.delegate = maskedDelegate
        
        view.addSubview(cardTextField)
    }
}
