//
//  OptionalValueState.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

class OptionalValueState: State {
    enum StateType {
        case numeric
        case literal
        case alphaNumeric
        case custom(char: Character, characterSet: CharacterSet)
    }
    
    let type: StateType
    
    func accepts(character char: Character) -> Bool {
        switch self.type {
            case .numeric:
                return CharacterSet.decimalDigits.isMember(character: char)
            case .literal:
                return CharacterSet.letters.isMember(character: char)
            case .alphaNumeric:
                return CharacterSet.alphanumerics.isMember(character: char)
            case .custom(_, let characterSet):
                return characterSet.isMember(character: char)
        }
    }
    
    override func accept(character char: Character) -> Next? {
        if self.accepts(character: char) {
            return Next(
                state: self.nextState(),
                insert: char,
                pass: true,
                value: char
            )
        } else {
            return Next(
                state: self.nextState(),
                insert: nil,
                pass: false,
                value: nil
            )
        }
    }

    init(
        child: State,
        type: StateType
    ) {
        self.type = type
        super.init(child: child)
    }
    
    override var debugDescription: String {
        switch self.type {
            case .literal:
                return "[a] -> " + (nil != self.child ? self.child!.debugDescription : "nil")
            case .numeric:
                return "[9] -> " + (nil != self.child ? self.child!.debugDescription : "nil")
            case .alphaNumeric:
                return "[-] -> " + (nil != self.child ? self.child!.debugDescription : "nil")
            case .custom(let char, _):
                return "[\(char)] -> " + (nil != self.child ? self.child!.debugDescription : "nil")
        }
    }
    
}
