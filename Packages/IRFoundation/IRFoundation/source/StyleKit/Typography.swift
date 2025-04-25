//
//  Typography.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import UIKit

/// Centralised typographic catalogue for the entire app.
///
/// Every text role is expressed as a case, grouped by nested enums that capture
/// natural hierarchies (e.g. *Body*, *Title*, *Control*).
/// - Keeps one-switch mapping between semantic intent and `UIFont`.
/// - Plays nicely with Dynamic Type via `UIFontMetrics`.
/// - Written in British English for consistency across the codebase.
public enum Typography {

    // MARK: - Primary categories (public façade)

    /// Immersive, billboard-sized copy (e.g. onboarding hero banners).
    case display(Display)

    /// Large navigation titles (e.g. Settings root, first-class headings).
    case largeTitle

    /// Section headings of varying depths.
    case title(Title)

    /// Prominent single-line heading inside cards or lists.
    case headline

    /// Secondary heading that follows a headline.
    case subheadline

    /// Body text with weight variants for emphasis.
    case body(Body)

    /// Supporting one-liners or in-cell meta.
    case callout

    /// Disclaimers, timestamps or metadata.
    case footnote

    /// Image captions, table headers or micro-labels.
    case caption(Caption)

    /// Monospaced digits for timers, code snippets or counters.
    case monospacedDigit

    /// Text on interactive controls such as buttons, tabs or the nav bar.
    case control(Control)

    /// Pill-style badge numbers or status indicators.
    case badge(Badge)

    // MARK: - Nested role enums ------------------------------------------------

    /// Display-scale variants.
    public enum Display: CaseIterable {
        /// 40 pt Regular hero text.
        case hero
    }

    /// Title hierarchy.
    public enum Title: CaseIterable {
        /// 28 pt Regular – top-level section header.
        case one
        /// 22 pt Regular – mid-level section header.
        case two
        /// 20 pt Regular – low-level section header.
        case three
    }

    /// Body-weight modifiers.
    public enum Body: CaseIterable {
        /// 17 pt Regular – default paragraph text.
        case regular
        /// 17 pt Medium – subtle highlight.
        case medium
        /// 17 pt Semibold – strong emphasis.
        case semibold
    }

    /// Caption sizes.
    public enum Caption: CaseIterable {
        /// 12 pt Regular – standard caption.
        case one
        /// 11 pt Regular – micro caption.
        case two
    }

    /// System control text.
    public enum Control: CaseIterable {
        /// 17 pt Semibold – button labels.
        case button
        /// 10 pt Regular – tab-bar item titles.
        case tabBar
        /// 17 pt Regular – compact nav-bar titles / back button text.
        case navigationBar
    }

    /// Badge sizes.
    public enum Badge: CaseIterable {
        /// 13 pt Semibold – standard pill badge.
        case normal
        /// 10 pt Regular – ultra-small badge inside icons.
        case micro
    }

    // MARK: - Font mapping -----------------------------------------------------

    /// Dynamic-Type-aware `UIFont` resolver.
    public func font() -> UIFont {
        let descriptor: (size: CGFloat,
                         weight: UIFont.Weight,
                         style: UIFont.TextStyle,
                         monospaced: Bool)

        switch self {
        case .display:                      descriptor = (40, .regular,  .largeTitle, false)
        case .largeTitle:                   descriptor = (34, .regular,  .largeTitle, false)

        case .title(.one):                  descriptor = (28, .regular,  .title1,     false)
        case .title(.two):                  descriptor = (22, .regular,  .title2,     false)
        case .title(.three):                descriptor = (20, .regular,  .title3,     false)

        case .headline:                     descriptor = (17, .semibold, .headline,   false)
        case .subheadline:                  descriptor = (15, .regular,  .subheadline,false)

        case .body(.regular):               descriptor = (17, .regular,  .body,       false)
        case .body(.medium):                descriptor = (17, .medium,   .body,       false)
        case .body(.semibold):              descriptor = (17, .semibold, .body,       false)

        case .callout:                      descriptor = (16, .regular,  .callout,    false)
        case .footnote:                     descriptor = (13, .regular,  .footnote,   false)

        case .caption(.one):                descriptor = (12, .regular,  .caption1,   false)
        case .caption(.two):                descriptor = (11, .regular,  .caption2,   false)

        case .monospacedDigit:              descriptor = (17, .regular,  .body,       true)

        case .control(.button):             descriptor = (17, .semibold, .body,       false)
        case .control(.tabBar):             descriptor = (10, .regular,  .caption2,   false)
        case .control(.navigationBar):      descriptor = (17, .regular,  .headline,   false)

        case .badge(.normal):               descriptor = (13, .semibold, .caption2,   false)
        case .badge(.micro):                descriptor = (10, .regular,  .caption2,   false)
        }

        let base = descriptor.monospaced
            ? UIFont.monospacedSystemFont(ofSize: descriptor.size, weight: descriptor.weight)
            : UIFont.systemFont(ofSize: descriptor.size, weight: descriptor.weight)

        return UIFontMetrics(forTextStyle: descriptor.style).scaledFont(for: base)
    }
}
