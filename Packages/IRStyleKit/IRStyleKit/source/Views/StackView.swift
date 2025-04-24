//
//  StackView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 23.04.2025.
//

import UIKit

@resultBuilder
public enum ArrangedSubviewsBuilder {
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        components
    }
}

public final class StackView: UIStackView {
    
    public enum Kind {
        case horizontal(spacing: CGFloat = 8)
        case vertical(spacing: CGFloat = 4)
    }
    
    public init(
        _ kind: Kind, @ArrangedSubviewsBuilder _ views: () throws -> [UIView]
    ) rethrows {
        super.init(frame: .zero)
        switch kind {
        case .horizontal(let spacing):
            axis = .horizontal
            self.spacing = spacing
        case .vertical(let spacing):
            axis = .vertical
            self.spacing = spacing
        }
        translatesAutoresizingMaskIntoConstraints = false
        for view in try views() {
            addArrangedSubview(view)
        }
    } 
    
    public required init(coder: NSCoder) {
        fatalError("Use init(_:views:) instead.")
    }
}
