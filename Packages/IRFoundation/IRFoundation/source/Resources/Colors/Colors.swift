//
//  Colors.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import UIKit

public enum Colors {
    //TODO: nested enums

    // MARK: – Text
    public static let primaryText   = Adaptive.Text.primary.resolvedColor
    public static let secondaryText = Adaptive.Text.secondary.resolvedColor

    // MARK: – Background
    public static let backgroundDefault  = Adaptive.BG.default.resolvedColor
    public static let backgroundElevated = Adaptive.BG.elevated.resolvedColor

    // MARK: – Border
    public static let borderDefault = Adaptive.Border.default.resolvedColor

    // MARK: – Accents
    public static let accentPrimary   = Adaptive.Accent.primary.resolvedColor
    public static let accentSecondary = Adaptive.Accent.secondary.resolvedColor
    public static let success         = Adaptive.Feedback.success.resolvedColor
    public static let warning         = Adaptive.Feedback.warning.resolvedColor
    public static let destructive     = Adaptive.Feedback.destructive.resolvedColor

    // MARK: – Overlays
    /// Used for `UIControl.isHighlighted`
    public static let pressedOverlay = Adaptive.Overlay.pressed.resolvedColor
}

