//
//  FormatSanitizer.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 25.02.2025.
//

import Foundation

class FormatSanitizer {
    func sanitize(formatString string: String) throws -> String {
        try self.checkOpenBraces(string)
        let blocks: [String] = self.divideBlocksWithMixedCharacters(self.getFormatBlocks(string))
        return self.sortFormatBlocks(blocks).joined(separator: "")
    }
}

private extension FormatSanitizer {
    
    func checkOpenBraces(_ string: String) throws {
        var escape:          Bool = false
        var squareBraceOpen: Bool = false
        var curlyBraceOpen:  Bool = false
        
        for char in string {
            if "\\" == char {
                escape = !escape
                continue
            }
            
            if "[" == char {
                if squareBraceOpen {
                    throw Compiler.CompilerError.wrongFormat
                }
                squareBraceOpen = true && !escape
            }
            
            if "]" == char && !escape {
                squareBraceOpen = false
            }
            
            if "{" == char {
                if curlyBraceOpen {
                    throw Compiler.CompilerError.wrongFormat
                }
                curlyBraceOpen = true && !escape
            }
            
            if "}" == char && !escape {
                curlyBraceOpen = false
            }
            
            escape = false
        }
    }
    
    func getFormatBlocks(_ string: String) -> [String] {
        var blocks:       [String] = []
        var currentBlock: String   = ""
        var escape:       Bool     = false
        
        for char in string {
            if "\\" == char {
                if !escape {
                    escape = true
                    currentBlock.append(char)
                    continue
                }
            }
            
            if ("[" == char || "{" == char) && !escape {
                if 0 < currentBlock.count {
                    blocks.append(currentBlock)
                }
                
                currentBlock = ""
            }
            
            currentBlock.append(char)
            
            if ("]" == char || "}" == char) && !escape {
                blocks.append(currentBlock)
                currentBlock = ""
            }
            
            escape = false
        }
        
        if !currentBlock.isEmpty {
            blocks.append(currentBlock)
        }
        
        return blocks
    }
    
    func divideBlocksWithMixedCharacters(_ blocks: [String]) -> [String] {
        var resultingBlocks: [String] = []
        
        for block in blocks {
            if block.hasPrefix("[") {
                var blockBuffer: String = ""
                for blockCharacter in block {
                    if blockCharacter == "[" {
                        blockBuffer.append(blockCharacter)
                        continue
                    }
                    
                    if blockCharacter == "]" && !blockBuffer.hasSuffix("\\") {
                        blockBuffer.append(blockCharacter)
                        resultingBlocks.append(blockBuffer)
                        break
                    }
                    
                    if blockCharacter == "0"
                    || blockCharacter == "9" {
                        if blockBuffer.contains("A")
                        || blockBuffer.contains("a")
                        || blockBuffer.contains("-")
                        || blockBuffer.contains("_") {
                            blockBuffer += "]"
                            resultingBlocks.append(blockBuffer)
                            blockBuffer = "[" + String(blockCharacter)
                            continue
                        }
                    }
                    
                    if blockCharacter == "A"
                    || blockCharacter == "a" {
                        if blockBuffer.contains("0")
                        || blockBuffer.contains("9")
                        || blockBuffer.contains("-")
                        || blockBuffer.contains("_") {
                            blockBuffer += "]"
                            resultingBlocks.append(blockBuffer)
                            blockBuffer = "[" + String(blockCharacter)
                            continue
                        }
                    }
                    
                    if blockCharacter == "-"
                    || blockCharacter == "_" {
                        if blockBuffer.contains("0")
                        || blockBuffer.contains("9")
                        || blockBuffer.contains("A")
                        || blockBuffer.contains("a") {
                            blockBuffer += "]"
                            resultingBlocks.append(blockBuffer)
                            blockBuffer = "[" + String(blockCharacter)
                            continue
                        }
                    }
                    
                    blockBuffer.append(blockCharacter)
                }
            } else {
                resultingBlocks.append(block)
            }
            
        }
        
        return resultingBlocks
    }
    
    func sortFormatBlocks(_ blocks: [String]) -> [String] {
        var sortedBlocks: [String] = []
        
        for block in blocks {
            var sortedBlock: String
            if block.hasPrefix("[") {
                if block.contains("0")
                || block.contains("9") {
                    sortedBlock = self.sortBlock(block: block)
                } else if block.contains("a")
                       || block.contains("A") {
                            sortedBlock = self.sortBlock(block: block)
                } else {
                    sortedBlock =
                        "["
                        + String(block
                                    .replacingOccurrences(of: "[", with: "")
                                    .replacingOccurrences(of: "]", with: "")
                                    .replacingOccurrences(of: "_", with: "A")
                                    .replacingOccurrences(of: "-", with: "a")
                                    .sorted()
                          )
                        + "]"
                    sortedBlock = sortedBlock
                                    .replacingOccurrences(of: "A", with: "_")
                                    .replacingOccurrences(of: "a", with: "-")
                }
            } else {
                sortedBlock = block
            }
            
            sortedBlocks.append(sortedBlock)
        }
        
        return sortedBlocks
    }
    
    private func sortBlock(block: String) -> String {
        return
            "["
            + String(block
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .sorted()
            )
            + "]"
    }
    
}
