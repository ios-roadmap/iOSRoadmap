//
//  Compiler.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

public class Compiler {
    
    private let customNotations: [Notation]
    public enum CompilerError: Error {
        case wrongFormat
    }

    init(customNotations: [Notation]) {
        self.customNotations = customNotations
    }

    func compile(formatString string: String) throws -> State {
        let sanitizedFormat: String = try FormatSanitizer().sanitize(formatString: string)
        
        return try self.compile(
            sanitizedFormat,
            valuable: false,
            fixed: false,
            lastCharacter: nil
        )
    }
}

private extension Compiler {
    
    func compile(
        _ string: String,
        valuable: Bool,
        fixed: Bool,
        lastCharacter: Character?
    ) throws -> State {
        guard
            let char: Character = string.first
        else {
            return EOLState()
        }
        
        switch char {
            case "[":
                if "\\" == lastCharacter { // escaped [
                    break
                }
                return try self.compile(
                    string.truncateFirst(),
                    valuable: true,
                    fixed: false,
                    lastCharacter: char
                )
            
            case "{":
                if "\\" == lastCharacter { // escaped {
                    break
                }
                return try self.compile(
                    string.truncateFirst(),
                    valuable: false,
                    fixed: true,
                    lastCharacter: char
                )
            
            case "]":
                if "\\" == lastCharacter { // escaped ]
                    break
                }
                return try self.compile(
                    string.truncateFirst(),
                    valuable: false,
                    fixed: false,
                    lastCharacter: char
                )
            
            case "}":
                if "\\" == lastCharacter { // escaped }
                    break
                }
                return try self.compile(
                    string.truncateFirst(),
                    valuable: false,
                    fixed: false,
                    lastCharacter: char
                )
            
            case "\\": // the escaping character
                if "\\" == lastCharacter { // escaped «\» character
                    break
                }
                return try self.compile(
                    string.truncateFirst(),
                    valuable: valuable,
                    fixed: fixed,
                    lastCharacter: char
                )
            
            default: break
        }
        
        if valuable {
            return try compileValuable(char, string: string, lastCharacter: lastCharacter)
        }
        
        if fixed {
            return FixedState(
                child: try self.compile(
                    string.truncateFirst(),
                    valuable: false,
                    fixed: true,
                    lastCharacter: char
                ),
                ownCharacter: char
            )
        }
        
        return FreeState(
            child: try self.compile(
                string.truncateFirst(),
                valuable: false,
                fixed: false,
                lastCharacter: char
            ),
            ownCharacter: char
        )
    }
    
    func compileValuable(_ char: Character, string: String, lastCharacter: Character?) throws -> State {
        switch char {
            case "0":
                return ValueState(
                    child: try self.compile(
                        string.truncateFirst(),
                        valuable: true,
                        fixed: false,
                        lastCharacter: char
                    ),
                    type: ValueState.StateType.numeric
                )
            
            case "A":
                return ValueState(
                    child: try self.compile(
                        string.truncateFirst(),
                        valuable: true,
                        fixed: false,
                        lastCharacter: char
                    ),
                    type: ValueState.StateType.literal
                )
            
            case "_":
                return ValueState(
                    child: try self.compile(
                        string.truncateFirst(),
                        valuable: true,
                        fixed: false,
                        lastCharacter: char
                    ),
                    type: ValueState.StateType.alphaNumeric
                )
            
            case "…":
                return ValueState(inheritedType: try self.determineInheritedType(forLastCharacter: lastCharacter))
            
            case "9":
                return OptionalValueState(
                    child: try self.compile(
                        string.truncateFirst(),
                        valuable: true,
                        fixed: false,
                        lastCharacter: char
                    ),
                    type: OptionalValueState.StateType.numeric
                )
            
            case "a":
                return OptionalValueState(
                    child: try self.compile(
                        string.truncateFirst(),
                        valuable: true,
                        fixed: false,
                        lastCharacter: char
                    ),
                    type: OptionalValueState.StateType.literal
                )
            
            case "-":
                return OptionalValueState(
                    child: try self.compile(
                        string.truncateFirst(),
                        valuable: true,
                        fixed: false,
                        lastCharacter: char
                    ),
                    type: OptionalValueState.StateType.alphaNumeric
                )
            
            default: return try self.compileWithCustomNotations(char, string: string)
        }
    }
    
    func determineInheritedType(forLastCharacter character: Character?) throws -> ValueState.StateType {
        guard
            let character: Character = character,
            String(character) != ""
        else {
            throw CompilerError.wrongFormat
        }
        
        switch character {
            case "0", "9":
                return ValueState.StateType.numeric
            
            case "A", "a":
                return ValueState.StateType.literal
            
            case "_", "-":
                return ValueState.StateType.alphaNumeric
            
            case "…":
                return ValueState.StateType.alphaNumeric
            
            case "[":
                return ValueState.StateType.alphaNumeric
            
            default: return try determineCustomStateType(forCharacter: character)
        }
    }
    
    func compileWithCustomNotations(_ char: Character, string: String) throws -> State {
        for notation in self.customNotations {
            if notation.character == char {
                if notation.isOptional {
                    return OptionalValueState(
                        child: try self.compile(
                            string.truncateFirst(),
                            valuable: true,
                            fixed: false,
                            lastCharacter: char
                        ),
                        type: OptionalValueState.StateType.custom(char: char, characterSet: notation.characterSet)
                    )
                } else {
                    return ValueState(
                        child: try self.compile(
                            string.truncateFirst(),
                            valuable: true,
                            fixed: false,
                            lastCharacter: char
                        ),
                        type: ValueState.StateType.custom(char: char, characterSet: notation.characterSet)
                    )
                }
            }
        }
        throw CompilerError.wrongFormat
    }
    
    func determineCustomStateType(forCharacter character: Character) throws -> ValueState.StateType {
        for notation in self.customNotations {
            if notation.character == character {
                return ValueState.StateType.custom(char: character, characterSet: notation.characterSet)
            }
        }
        throw CompilerError.wrongFormat
    }
    
}
