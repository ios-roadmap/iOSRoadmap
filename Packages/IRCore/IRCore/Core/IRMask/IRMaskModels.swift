//
//  IRMaskModels.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 28.02.2025.
//

import Foundation

//public struct IRMaskDefinition {
//    public let patternType: IRMaskPatternType
//    
//    public init(patternType: IRMaskPatternType) {
//        self.patternType = patternType
//    }
//}

public enum IRMaskPatternType {
    case creditCardNumber,
         iban,
         custom(String)
    
    public var format: String {
        switch self {
        case .creditCardNumber:
            return "nnnn nnnn nnnn nnnn"
        case .iban:
            return "TRnn nnnn nnnn nnnn nnnn nnnn nn"
        case .custom(let pattern):
            return pattern
        }
    }
    
    public func format(raw: String) -> String {
        let cleanDigits = raw.onlyDigits()
        var formattedText = ""
        var digitIndex = 0
        
        for maskChar in format {
            if maskChar == "n" {
                if digitIndex < cleanDigits.count {
                    let index = cleanDigits.index(cleanDigits.startIndex, offsetBy: digitIndex)
                    formattedText.append(cleanDigits[index])
                    digitIndex += 1
                } else {
                    formattedText.append(" ")
                }
            } else {
                formattedText.append(maskChar)
            }
        }
        return formattedText
    }
}

public enum IRMaskCompletionState {
    case empty
    case incomplete
    case complete
}

