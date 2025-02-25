import UIKit

// Enum to define available input format patterns
enum InputFormat: String {
    case custom = "---- **-- **** ----" // Masked format pattern
}

// Enum to define the disabled character for masking
enum DisabledCharacter: Character {
    case mask = "*"
}

class MaskedCardTextField: UITextField, UITextFieldDelegate {
    
    private var inputFormat: InputFormat = .custom // Stores the selected input format
    private var disabledCharacter: DisabledCharacter = .mask // Stores the selected mask character
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // Configures the text field with the given format and mask character
    func configure(format: InputFormat, mask: DisabledCharacter) {
        self.inputFormat = format
        self.disabledCharacter = mask
        self.text = formattedMaskedText("") // Apply format initially
    }
    
    // Initial setup for text field properties
    private func setup() {
        self.delegate = self
        self.keyboardType = .numberPad
        self.tintColor = .clear // Hide cursor
        self.text = formattedMaskedText("")
    }
    
    // Handles text changes within the text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        
        if string.isEmpty {
            return handleBackspace(textField, range: range)
        }
        
        // Allow only numeric input
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        // Remove spaces and keep only numeric characters
        let cleanText = currentText.replacingOccurrences(of: " ", with: "").filter { $0.isNumber }
        
        // Restrict input to the maximum allowed characters in the format
        if cleanText.count >= inputFormat.rawValue.filter({ $0 == "-" }).count {
            return false
        }
        
        // Update text and format it accordingly
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedMaskedText(updatedText)
        moveCursorToCorrectPosition(textField, in: range, replacementString: string)
        
        return false
    }
    
    // Handles backspace action properly to maintain the format
    private func handleBackspace(_ textField: UITextField, range: NSRange) -> Bool {
        guard var text = textField.text else { return false }

        if range.location > 0 {
            var newLocation = range.location - 1
            
            // Move cursor backward until a number is found
            while newLocation > 0 {
                let checkIndex = text.index(text.startIndex, offsetBy: newLocation)
                if text[checkIndex].isNumber {
                    break
                }
                newLocation -= 1
            }

            // Ensure the deleted character is a number
            if !text[text.index(text.startIndex, offsetBy: newLocation)].isNumber {
                return false
            }

            // Remove the character and reformat the text
            text.remove(at: text.index(text.startIndex, offsetBy: newLocation))
            textField.text = formattedMaskedText(text)
            moveCursorToCorrectPosition(textField, in: NSRange(location: newLocation + 1, length: 0), replacementString: "")
            
            return false
        }
        
        return true
    }
    
    // Applies the predefined format to the entered text
    private func formattedMaskedText(_ rawText: String) -> String {
        let cleanText = rawText.replacingOccurrences(of: " ", with: "").filter { $0.isNumber }
        let formatPattern = inputFormat.rawValue
        
        var formattedText = ""
        var index = 0
        
        for char in formatPattern {
            if char == "-" {
                if index < cleanText.count {
                    formattedText.append(cleanText[cleanText.index(cleanText.startIndex, offsetBy: index)])
                    index += 1
                } else {
                    formattedText.append(" ")
                }
            } else if char == "*" {
                formattedText.append(disabledCharacter.rawValue)
            } else {
                formattedText.append(char)
            }
        }
        
        return formattedText
    }
    
    // Adjusts cursor position after text modification
    private func moveCursorToCorrectPosition(_ textField: UITextField, in range: NSRange, replacementString string: String) {
        guard let text = textField.text else { return }
        
        let formatPattern = inputFormat.rawValue
        let allowedIndexes = getInputFieldIndexes(from: formatPattern) // Get only editable positions
        var newOffset = range.location + string.count
        
        if string.isEmpty { // Handling deletion
            while newOffset > 0 {
                let prevIndex = newOffset - 1
                if allowedIndexes.contains(prevIndex) {
                    break
                }
                newOffset -= 1
            }
        } else { // Handling insertion
            while newOffset < formatPattern.count {
                if allowedIndexes.contains(newOffset) {
                    break
                }
                newOffset += 1
            }
        }

        if let position = textField.position(from: textField.beginningOfDocument, offset: newOffset) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
    }
    
    // Retrieves the indexes of the editable character positions in the format
    private func getInputFieldIndexes(from format: String) -> [Int] {
        var indexes: [Int] = []
        for (index, char) in format.enumerated() {
            if char == "-" {
                indexes.append(index)
            }
        }
        return indexes
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Initialize and configure the masked text field
        let cardTextField = MaskedCardTextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        cardTextField.borderStyle = .roundedRect
        cardTextField.configure(format: .custom, mask: .mask)
        view.addSubview(cardTextField)
    }
}
