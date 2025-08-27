//
//  CircleLabelView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 27.08.2025.
//

import UIKit

public final class CircleLabelImageViewModel {
    public let text: String
    public let textColor: UIColor
    public let font: UIFont
    public let circleColor: UIColor
    public let size: CGSize
    
    public init(
        text: String,
        textColor: UIColor = .white,
        font: UIFont = .boldSystemFont(ofSize: 18),
        circleColor: UIColor = .systemRed,
        size: CGSize = CGSize(width: 80, height: 80)
    ) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.circleColor = circleColor
        self.size = size
    }
}

public final class CircleLabelImage: UIImage {
    
    public convenience init(viewModel: CircleLabelImageViewModel) {
        let renderer = UIGraphicsImageRenderer(size: viewModel.size)
        let image = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: viewModel.size)
            let path = UIBezierPath(ovalIn: rect)
            
            // Daire doldur
            viewModel.circleColor.setFill()
            path.fill()
            
            // Yazı çiz
            let attributes: [NSAttributedString.Key: Any] = [
                .font: viewModel.font,
                .foregroundColor: viewModel.textColor
            ]
            
            let textSize = viewModel.text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (viewModel.size.width - textSize.width) / 2,
                y: (viewModel.size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            viewModel.text.draw(in: textRect, withAttributes: attributes)
        }
        self.init(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
    }
}
