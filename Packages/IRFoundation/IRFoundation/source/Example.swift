import UIKit

private extension String {
    func renderedWidth(using font: UIFont) -> CGFloat {
        let size = (self as NSString)
            .size(withAttributes: [.font: font])
        return ceil(size.width)
    }
}

extension UILabel {
    /// Wraps words to `maxWidth`, printing debug info per line/word.
    func wrapWordsDebug(to maxWidth: CGFloat) {
        guard
            let text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !text.isEmpty
        else { return }

        let font = self.font ?? .systemFont(ofSize: UIFont.systemFontSize)
        let paragraphs = text.components(separatedBy: .newlines)
        var wrappedLines: [String] = []

        for (pIndex, paragraph) in paragraphs.enumerated() {
            print("--- Paragraph \(pIndex + 1) start — “\(paragraph)”")
            let words = paragraph
                .split(separator: " ", omittingEmptySubsequences: true)
                .map(String.init)

            var currentLine = ""
            for (wIndex, word) in words.enumerated() {
                let candidate = currentLine.isEmpty
                    ? word
                    : "\(currentLine) \(word)"

                let currentWidth = currentLine.renderedWidth(using: font)
                let wordWidth = word.renderedWidth(using: font)
                let candidateWidth = candidate.renderedWidth(using: font)

                print("""
                    [Word \(wIndex + 1)] “\(word)”
                      currentLine: “\(currentLine)” width: \(currentWidth)
                      candidate:   “\(candidate)” width: \(candidateWidth)
                      maxWidth:    \(maxWidth)
                    """)

                if candidateWidth <= maxWidth {
                    currentLine = candidate
                } else {
                    print("→ Overflow! Flushing “\(currentLine)” as line, starting new line with “\(word)”\n")
                    wrappedLines.append(currentLine)
                    currentLine = word
                }
            }

            if !currentLine.isEmpty {
                print("→ End of paragraph flush “\(currentLine)”\n")
                wrappedLines.append(currentLine)
            }
        }

        self.text = wrappedLines.joined(separator: "\n")
        self.numberOfLines = 0
    }
}
