//
//  CharacterSet.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

public extension CharacterSet {

    func isMember(character: Character) -> Bool {
        let string: String = String(character)
        for char in string.unicodeScalars {
            if !self.contains(char) {
                return false
            }
        }
        
        return true
    }
    
}
