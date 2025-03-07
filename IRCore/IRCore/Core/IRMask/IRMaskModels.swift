//
//  IRMaskModels.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 28.02.2025.
//

import Foundation

public struct IRMaskDefinition {
    public let patternType: IRMaskPatternType
    
    public init(patternType: IRMaskPatternType) {
        self.patternType = patternType
    }
}

public enum IRMaskPatternType {
    case creditCardNumber,
         iban,
         custom(String)
    
    var format: String {
        switch self {
        case .creditCardNumber:
            return "nnnn nnnn nnnn nnnn"
        case .iban:
            return "TRnn nnnn nnnn nnnn nnnn nnnn nn"
        case .custom(let pattern):
            return pattern
        }
    }
}

public enum IRMaskCompletionState {
    case empty
    case incomplete
    case complete
}
