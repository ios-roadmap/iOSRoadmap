//
//  CaretString.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

public struct CaretString: CustomDebugStringConvertible, CustomStringConvertible, Equatable {
    
    public let string: String
    public let caretPosition: String.Index
    public let caretGravity: CaretGravity
    public init(string: String, caretPosition: String.Index, caretGravity: CaretGravity) {
        self.string        = string
        self.caretPosition = caretPosition
        self.caretGravity  = caretGravity
    }

    public var debugDescription: String {
        return "STRING: \(self.string)\nCARET POSITION: \(self.caretPosition)\nCARET GRAVITY: \(self.caretGravity)"
    }
    
    public var description: String {
        return self.debugDescription
    }

    func reversed() -> CaretString {
        let reversedString:        String       = self.string.reversed
        let caretPositionInt:      Int          = self.string.distanceFromStartIndex(to: self.caretPosition)
        let reversedCaretPosition: String.Index = reversedString.startIndex(offsetBy: self.string.count - caretPositionInt)
        return CaretString(
            string: reversedString,
            caretPosition: reversedCaretPosition,
            caretGravity: self.caretGravity
        )
    }

    public enum CaretGravity: Equatable {
        case forward(autocomplete: Bool)
        case backward(autoskip: Bool)
        var autocomplete: Bool {
            if case CaretGravity.forward(let autocomplete) = self {
                return autocomplete
            }
            return false
        }
        var autoskip: Bool {
            if case CaretGravity.backward(let autoskip) = self {
                return autoskip
            }
            return false
        }
    }
    
}


public func ==(left: CaretString, right: CaretString) -> Bool {
    return left.caretPosition == right.caretPosition
        && left.string        == right.string
        && left.caretGravity  == right.caretGravity
}
