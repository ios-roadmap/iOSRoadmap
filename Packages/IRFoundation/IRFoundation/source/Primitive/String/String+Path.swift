//
//  String+Path.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import Foundation

// MARK: Purpose File-system & URL path conveniences.

/// Expand tilde, resolve .., normalise slashes.
/// Append / delete path components immutably.
/// File-name sanitiser (remove illegal characters).
/// MIME-type inference from extension.
/// Temporary-file name generator with collision resistance.
