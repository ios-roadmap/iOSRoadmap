import UIKit

enum InputFormat: String {
    case custom = "---- **-- **** ----"
}

enum DisabledCharacter: Character {
    case mask = "*"
}

class MaskedCardTextField: UITextField, UITextFieldDelegate {
    
    private var inputFormat: InputFormat = .custom
    private var disabledCharacter: DisabledCharacter = .mask
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func configure(format: InputFormat, mask: DisabledCharacter) {
        self.inputFormat = format
        self.disabledCharacter = mask
        self.text = formattedMaskedText("") // Başlangıçta format uygula
    }
    
    private func setup() {
        self.delegate = self
        self.keyboardType = .numberPad
        self.tintColor = .clear //Cursor gizle
        self.text = formattedMaskedText("") // Başlangıçta format uygula
        self.addTarget(self, action: #selector(moveCursorToBeginning), for: .editingDidBegin)
    }
    
    @objc private func moveCursorToBeginning() {
        DispatchQueue.main.async {
            if let startPosition = self.position(from: self.beginningOfDocument, offset: 0) {
                self.selectedTextRange = self.textRange(from: startPosition, to: startPosition)
            }
            self.tintColor = .tintColor
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        
        if string.isEmpty {
            return handleBackspace(textField, range: range)
        }
        
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        let cleanText = currentText.replacingOccurrences(of: " ", with: "").filter { $0.isNumber }
        if cleanText.count >= inputFormat.rawValue.filter({ $0 == "-" }).count {
            return false
        }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedMaskedText(updatedText)
        moveCursorToCorrectPosition(textField, in: range, replacementString: string)
        
        return false
    }
    
    private func handleBackspace(_ textField: UITextField, range: NSRange) -> Bool {
        guard var text = textField.text else { return false }

        if range.location > 0 {
            var newLocation = range.location - 1
            
            while newLocation > 0 {
                let checkIndex = text.index(text.startIndex, offsetBy: newLocation)
                if text[checkIndex].isNumber {
                    break
                }
                newLocation -= 1
            }

            if !text[text.index(text.startIndex, offsetBy: newLocation)].isNumber {
                return false
            }

            let deleteRange = NSRange(location: newLocation, length: 1)
            text.remove(at: text.index(text.startIndex, offsetBy: newLocation))

            textField.text = formattedMaskedText(text)
            moveCursorToCorrectPosition(textField, in: NSRange(location: newLocation + 1, length: 0), replacementString: "")

            return false
        }

        return true
    }

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
    
    private func moveCursorToCorrectPosition(_ textField: UITextField, in range: NSRange, replacementString string: String) {
        guard let text = textField.text else { return }
        
        let disabledMask = disabledCharacter.rawValue // Enum'dan mask karakterini al
        let formatPattern = inputFormat.rawValue // Format string'ini al
        let allowedIndexes = getInputFieldIndexes(from: formatPattern) // Yalnızca "-" olan indeksleri al
        var newOffset = range.location + string.count
        
        if string.isEmpty { // Silme işlemi
            while newOffset > 0 {
                let prevIndex = newOffset - 1
                if allowedIndexes.contains(prevIndex) {
                    break
                }
                newOffset -= 1
            }
        } else { // Yazma işlemi
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

    // "-" karakterlerinin indekslerini al (sadece input girilebilen yerler)
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

    let cardTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let cardTextField = MaskedCardTextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        cardTextField.borderStyle = .roundedRect
        cardTextField.configure(format: .custom, mask: .mask)
        view.addSubview(cardTextField)

        NSLayoutConstraint.activate([
            cardTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardTextField.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
}
