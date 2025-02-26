//
//  State.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

class State: CustomDebugStringConvertible, CustomStringConvertible {
    
    let child: State?
    
    func accept(character char: Character) -> Next? {
        fatalError("accept(character:) method is abstract")
    }

    func autocomplete() -> Next? {
        return nil
    }

    func nextState() -> State {
        return self.child!
    }
    
    init(child: State?) {
        self.child = child
    }
    
    var debugDescription: String {
        return "BASE -> " + (nil != self.child ? self.child!.debugDescription : "nil")
    }
    
    var description: String {
        return self.debugDescription
    }
    
}
