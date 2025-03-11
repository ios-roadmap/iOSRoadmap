//
//  IRMaskInputFieldDelegate.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 28.02.2025.
//

import UIKit

public class IRMaskedInputFieldDelegate: NSObject, UITextFieldDelegate {
    private let formatter: IRMaskFormatterType
    private let maskDefinition: IRMaskDefinition
    private var lastCursorOffset: Int = 0
    
    public var onCompletionStateChanged: ((IRMaskCompletionState) -> Void)?

    public var placeholder: String {
        return formatter.instance.format(text: "", with: maskDefinition)
    }
    
    private var allowedIndexes: [Int] {
        return maskDefinition.patternType.format.indices(for: "n")
    }
    
    public init(
        formatter: IRMaskFormatterType,
        maskDefinition: IRMaskDefinition,
        onCompletionStateChanged: ((IRMaskCompletionState) -> Void)? = nil
    ) {
        self.formatter = formatter
        self.maskDefinition = maskDefinition
        self.onCompletionStateChanged = onCompletionStateChanged
    }
    
    // MARK: - UITextFieldDelegate Methods
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = .clear
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let firstIndex = allowedIndexes.first {
                lastCursorOffset = firstIndex
                textField.setCursorPosition(offset: firstIndex)
            }
            textField.tintColor = .label
        }
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }

        if string.isEmpty {
            return handleBackspace(in: textField, range: range)
        }
        
        guard !string.containsEmoji else { return false }
        
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        let cleanDigits = currentText.onlyDigits()
        let maxDigits = maskDefinition.patternType.format.filter { $0 == "n" }.count
        if cleanDigits.count >= maxDigits { return false }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        textField.text = formatter.instance.format(text: updatedText, with: maskDefinition)

        if string.count > 1 {
            lastCursorOffset = lastInsertedNIndex(in: textField.text ?? "")
        } else {
            updateCursorPosition(in: textField, range: range, replacementString: string)
        }
        
        textField.setCursorPosition(offset: lastCursorOffset)
        
        notifyCompletionState(text: textField.text ?? "")
        
        return false
    }

    public func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.setCursorPosition(offset: lastCursorOffset)
    }
}

// MARK: - MaskedTextFieldDelegate Helpers

extension IRMaskedInputFieldDelegate {
    func handleBackspace(in textField: UITextField, range: NSRange) -> Bool {
        guard var text = textField.text, !text.onlyDigits().isEmpty else {
            notifyCompletionState(text: textField.text ?? "")
            return false
        }
        guard let indexToRemove = text.lastDigitIndex() else { return false }
        
        text.remove(at: text.index(text.startIndex, offsetBy: indexToRemove))
        textField.text = formatter.instance.format(text: text, with: maskDefinition)
        lastCursorOffset = min(indexToRemove, textField.text?.count ?? 0)
        textField.setCursorPosition(offset: lastCursorOffset)
        
        notifyCompletionState(text: textField.text ?? "")
        
        return false
    }
    
    func updateCursorPosition(in textField: UITextField,
                              range: NSRange,
                              replacementString string: String) {
        let pattern = maskDefinition.patternType.format
        var newOffset = range.location + string.count
        
        if string.isEmpty {
            while newOffset > 0 {
                if allowedIndexes.contains(newOffset - 1) { break }
                newOffset -= 1
            }
        } else {
            while newOffset < pattern.count {
                if allowedIndexes.contains(newOffset) { break }
                newOffset += 1
            }
        }
        lastCursorOffset = newOffset
    }
    
    private func lastInsertedNIndex(in text: String) -> Int {
        let digitIndexes = allowedIndexes.filter { $0 < text.count }
        
        for index in digitIndexes.reversed() {
            if text[text.index(text.startIndex, offsetBy: index)].isNumber {
                return index + 1
            }
        }
        
        return allowedIndexes.first ?? text.count
    }

    private func notifyCompletionState(text: String) {
        let digitCount = text.onlyDigits().count
        let requiredDigits = maskDefinition.patternType.format.filter { $0 == "n" }.count
        
        let state: IRMaskCompletionState
        if digitCount == 0 {
            state = .empty
        } else if digitCount < requiredDigits {
            state = .incomplete
        } else {
            state = .complete
        }
        
        onCompletionStateChanged?(state)
    }
} 
