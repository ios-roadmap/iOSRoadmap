import UIKit

private extension String {
    func renderedWidth(using font: UIFont) -> CGFloat {
        let size = (self as NSString)
            .size(withAttributes: [.font: font])
        return ceil(size.width)
    }
}

extension UILabel {
    /// Inserts “\n” so that every line’s width ≤ `maxWidth`.
    /// Resets its width-counter at each new line.
    func wrapWords(to maxWidth: CGFloat) {
        guard
            let text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !text.isEmpty
        else { return }

        let font = self.font ?? .systemFont(ofSize: UIFont.systemFontSize)

        // Honour any existing line breaks, then re-wrap each paragraph.
        let paragraphs = text.components(separatedBy: .newlines)
        var wrappedLines: [String] = []

        for paragraph in paragraphs {
            let words = paragraph
                .split(separator: " ", omittingEmptySubsequences: true)
                .map(String.init)

            var currentLine = ""
            for word in words {
                let candidate = currentLine.isEmpty
                    ? word
                    : "\(currentLine) \(word)"

                if candidate.renderedWidth(using: font) <= maxWidth {
                    currentLine = candidate
                } else {
                    // flush previous line, reset width for new one
                    wrappedLines.append(currentLine)
                    currentLine = word
                }
            }
            if !currentLine.isEmpty {
                wrappedLines.append(currentLine)
            }
        }

        self.text = wrappedLines.joined(separator: "\n")
        self.numberOfLines = 0
    }
}
