//
//  IRDashboardEntity.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 19.02.2025.
//

import Foundation

public struct IRDashboardItem {
    public let title: String
    public let value: String
    public let icon: String
    
    public init(title: String, value: String, icon: String) {
        self.title = title
        self.value = value
        self.icon = icon
    }
}
