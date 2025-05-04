//
//  String+FormatDates.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import Foundation

// MARK: Purpose Date / time stringification and parsing.

/// ISO-8601, RFC 2822, HTTP date helpers.
/// Relative strings (“yesterday”, “in 2 h”) with threshold tuning.
/// Calendar-aware formatting (week of year, quarter).
/// Flexible parser that gracefully falls back through multiple layouts.
/// Time-zone conversion shortcuts (UTC→local, local→TZ).

