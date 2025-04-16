//
//  FontSize.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import UIKit

public enum FontSize: CaseIterable {
    /// 34pt – Primary headers, e.g. main screen titles
    case largeTitle

    /// 28pt – Page titles or prominent headings
    case title1

    /// 22pt – Secondary headings, e.g. subsections
    case title2

    /// 20pt – Tertiary headers or section labels
    case title3

    /// 17pt – Default body text across the app
    case body

    /// 16pt – Supplementary info, e.g. subtitles or side labels
    case callout

    /// 13pt – Additional context below titles or inputs
    case footnote

    /// 12pt – Tiny labels, e.g. timestamps or metadata
    case caption

    public var pointSize: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title1:     return 28
        case .title2:     return 22
        case .title3:     return 20
        case .body:       return 17
        case .callout:    return 16
        case .footnote:   return 13
        case .caption:    return 12
        }
    }

    public var textStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title1:     return .title1
        case .title2:     return .title2
        case .title3:     return .title3
        case .body:       return .body
        case .callout:    return .callout
        case .footnote:   return .footnote
        case .caption:    return .caption1
        }
    }
}
