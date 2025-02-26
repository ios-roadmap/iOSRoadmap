//
//  EOLState.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

class EOLState: State {
    
    convenience init() {
        self.init(child: nil)
    }
    
    override init(child: State?) {
        super.init(child: nil)
    }
    
    override func nextState() -> State {
        return self
    }
    
    override func accept(character char: Character) -> Next? {
        return nil
    }
    
    override var debugDescription: String {
        return "EOL"
    }
    
}
