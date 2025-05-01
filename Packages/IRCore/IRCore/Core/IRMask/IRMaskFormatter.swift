//
//  IRMaskFormatter.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 28.02.2025.
//

import Foundation

@MainActor
public enum IRMaskFormatterType {
    case generic
    
    var instance: IRMaskFormatter {
        switch self {
        case .generic:
            return GenericMaskFormatter()
        }
    }
}

@MainActor
protocol IRMaskFormatter {
    func format(text: String, with definition: IRMaskDefinition) -> String
}

final class GenericMaskFormatter: IRMaskFormatter {
    
    func format(text: String, with definition: IRMaskDefinition) -> String {
        let cleanDigits = text.onlyDigits()
        var formattedText = ""
        var digitIndex = 0
        
        for maskChar in definition.patternType.format {
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
