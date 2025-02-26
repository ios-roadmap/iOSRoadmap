//
// Project «InputMask»
// Created by Jeorge Taflanidi
//

import Foundation
import UIKit

public extension String {
    
    var reversed: String {
        return String(self.reversed())
    }
    
    func truncateFirst() -> String {
        return String(self[self.index(after: self.startIndex)...])
    }
    
    func prefixIntersection(with string: String) -> Substring {
        var lhsIndex = startIndex
        var rhsIndex = string.startIndex
        
        while lhsIndex != endIndex && rhsIndex != string.endIndex {
            if self[lhsIndex] == string[rhsIndex] {
                lhsIndex = index(after: lhsIndex)
                rhsIndex = string.index(after: rhsIndex)
            } else {
                return self[..<lhsIndex]
            }
        }
        
        return self[..<lhsIndex]
    }
    
    func reversedFormat() -> String {
        return String(
            String(self.reversed())
                .replacingOccurrences(of: "[\\", with: "\\]")
                .replacingOccurrences(of: "]\\", with: "\\[")
                .replacingOccurrences(of: "{\\", with: "\\}")
                .replacingOccurrences(of: "}\\", with: "\\{")
                .map { (c: Character) -> Character in
                    switch c {
                    case "[": return "]"
                    case "]": return "["
                    case "{": return "}"
                    case "}": return "{"
                    default: return c
                    }
                }
        )
    }
    
    func distanceFromStartIndex(to index: String.Index) -> Int {
        return self.distance(from: self.startIndex, to: index)
    }
    
    func startIndex(offsetBy offset: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: offset)
    }
    
    func extractDigits() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func numberOfOccurrencesOf(_ string: String) -> Int {
        return self.components(separatedBy: string).count - 1
    }
    
    func boxSizeWithFont(_ font: UIFont) -> CGSize {
        var size = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        size.width = size.width.rounded(.up)
        size.height = size.height.rounded(.up)
        return size
    }
}
