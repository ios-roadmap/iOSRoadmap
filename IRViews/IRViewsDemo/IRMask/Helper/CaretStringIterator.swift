//
//  CaretStringIterator.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

class CaretStringIterator {
    
    let caretString: CaretString
    var currentIndex: String.Index
    
    init(caretString: CaretString) {
        self.caretString  = caretString
        self.currentIndex = self.caretString.string.startIndex
    }
    
    func insertionAffectsCaret() -> Bool {
        let currentIndex:  Int = self.caretString.string.distanceFromStartIndex(to: self.currentIndex)
        let caretPosition: Int = self.caretString.string.distanceFromStartIndex(to: self.caretString.caretPosition)
        
        switch self.caretString.caretGravity {
            case .backward:
                return self.currentIndex < self.caretString.caretPosition
            
            case .forward:
                return self.currentIndex <= self.caretString.caretPosition
                    || (0 == currentIndex && 0 == caretPosition)
        }
    }
    
    func deletionAffectsCaret() -> Bool {
        return self.currentIndex < self.caretString.caretPosition
    }

    func next() -> Character? {
        if self.currentIndex >= self.caretString.string.endIndex {
            return nil
        }
        
        let character: Character = self.caretString.string[self.currentIndex]
        self.currentIndex = self.caretString.string.index(after: self.currentIndex)
        return character
    }
    
}
