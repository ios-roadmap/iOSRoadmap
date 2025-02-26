//
//  Notation.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

public struct Notation {
    let character: Character
    let characterSet: CharacterSet
    let isOptional: Bool
    
    public init(character: Character, characterSet: CharacterSet, isOptional: Bool) {
        self.character    = character
        self.characterSet = characterSet
        self.isOptional   = isOptional
    }
    
}
