//
//  FreeState.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

class FreeState: State {
    
    let ownCharacter: Character
    
    override func accept(character char: Character) -> Next? {
        if self.ownCharacter == char {
            return Next(
                state: self.nextState(),
                insert: char,
                pass: true,
                value: nil
            )
        } else {
            return Next(
                state: self.nextState(),
                insert: self.ownCharacter,
                pass: false,
                value: nil
            )
        }
    }
    
    override func autocomplete() -> Next? {
        return Next(
            state: self.nextState(),
            insert: self.ownCharacter,
            pass: false,
            value: nil
        )
    }

    init(
        child: State,
        ownCharacter: Character
    ) {
        self.ownCharacter = ownCharacter
        super.init(child: child)
    }
    
    override var debugDescription: String {
        return "\(self.ownCharacter) -> " + (nil != self.child ? self.child!.debugDescription : "nil")
    }
    
}
