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
public enum Typography: Equatable {
    
    // MARK: - Primary categories (public façade)
    
    /// 40 pt Regular – billboard hero banners.
    case display(Display)
    
    /// 34 pt Bold – large navigation titles.
    case largeTitle
    
    /// Section headers (28/22/20 pt).
    case title(Title)
    
    /// 17 pt Semibold – list or card headlines.
    case headline
    
    /// 15 pt Regular – secondary headings.
    case subheadline
    
    /// 17 pt Regular/Medium/Semibold – body text variants.
    case body(Body)
    
    /// 16 pt Regular – supporting callouts or labels.
    case callout
    
    /// 13 pt Regular – disclaimers, timestamps.
    case footnote
    
    /// 12/11 pt Regular – captions for images or micro-labels.
    case caption(Caption)
    
    /// 17 pt Regular (monospaced) – timers, counters.
    case monospacedDigit
    
    /// 17/10 pt – text on buttons, tabs, or nav bars.
    case control(Control)
    
    /// 13/10 pt – badge numbers, indicators.
    case badge(Badge)
    
    // MARK: - Nested role enums ------------------------------------------------
    
    public enum Display: CaseIterable {
        /// 40 pt Regular – immersive hero text.
        case hero
    }
    
    public enum Title: CaseIterable {
        /// 28 pt Regular – top-level header.
        case one
        /// 22 pt Regular – mid-level header.
        case two
        /// 20 pt Regular – low-level header.
        case three
    }
    
    public enum Body: CaseIterable {
        /// 17 pt Regular – standard paragraph.
        case regular
        /// 17 pt Medium – slightly emphasised.
        case medium
        /// 17 pt Semibold – strongly emphasised.
        case semibold
    }
    
    public enum Caption: CaseIterable {
        /// 12 pt Regular – standard caption.
        case one
        /// 11 pt Regular – micro caption.
        case two
    }
    
    public enum Control: CaseIterable {
        /// 17 pt Semibold – button titles.
        case button
        /// 10 pt Regular – tab bar items.
        case tabBar
        /// 17 pt Regular – navigation bar titles.
        case navigationBar
    }
    
    public enum Badge: CaseIterable {
        /// 13 pt Semibold – normal badge.
        case normal
        /// 10 pt Regular – micro badge.
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
