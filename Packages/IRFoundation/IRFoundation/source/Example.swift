import UIKit

private extension String {
    /// Returns the rendered width of the string with the given font.
    func renderedWidth(using font: UIFont) -> CGFloat {
        let size = (self as NSString)
            .size(withAttributes: [.font: font])
        return ceil(size.width)
    }
}

extension UILabel {

    /// Inserts `\n` so that *every* line’s width ≤ `maxWidth`.
    /// Greedy pack-per-line; does **not** break words.
    ///
    /// - Parameter maxWidth: Maximum allowed width for a single line, in points.
    func wrapWords(to maxWidth: CGFloat) {
        guard
            var raw = text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !raw.isEmpty
        else { return }

        let font = self.font ?? .systemFont(ofSize: 17)

        // Whole string fits—nothing to do.
        if raw.renderedWidth(using: font) <= maxWidth { return }

        let words = raw.split(separator: " ")
        var lines: [String] = []
        var currentLine = ""

        for wordSub in words {
            let word = String(wordSub)

            if currentLine.isEmpty {
                currentLine = word
                continue
            }

            let candidate = currentLine + " " + word
            if candidate.renderedWidth(using: font) <= maxWidth {
                currentLine = candidate
            } else {
                lines.append(currentLine)
                currentLine = word
            }
        }

        // Flush last line.
        if !currentLine.isEmpty { lines.append(currentLine) }

        raw = lines.joined(separator: "\n")
        text = raw
        numberOfLines = 0
    }
}
