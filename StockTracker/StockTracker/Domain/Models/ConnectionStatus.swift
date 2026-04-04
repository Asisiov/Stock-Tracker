//
//  ConnectionStatus.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

enum ConnectionStatus: String, Codable, Equatable {
    case connected
    case disconnected
    
    var color: Color {
        switch self {
        case .connected:
            return .positive
        case .disconnected:
            return .negative
        }
    }
    
    var title: String {
        switch self {
        case .connected:
            return String(localized: LocalizedStrings.ConnectionStatus.connected)
        case .disconnected:
            return String(localized: LocalizedStrings.ConnectionStatus.disconnected)
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .connected:
            return .positive
        case .disconnected:
            return .negative
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .connected:
            return .darkGreen
        case .disconnected:
            return .darkNegative
        }
    }
    
    var inverseBackgroundColor: Color {
        switch self {
        case .connected:
            return .darkNegative
        case .disconnected:
            return .darkGreen
        }
    }
}

// MARK: - ConnectionStatus + Feed

extension ConnectionStatus {
    
    private var isFeedRunning: Bool {
        self == .connected
    }
    
    var feedTitle: String {
        String(localized: LocalizedStrings.Feed.title)
    }
    
    var feedDescriptionText: String {
        isFeedRunning
        ? String(localized: LocalizedStrings.Feed.feedRunning)
        : String(localized: LocalizedStrings.Feed.feedNotRunning)
    }
    
    var feedButtonTitle: String {
        isFeedRunning
        ? String(localized: LocalizedStrings.Feed.stopFeed)
        : String(localized: LocalizedStrings.Feed.startFeed)
    }
    
    var feedButtonIconName: String {
        isFeedRunning ? "stop.fill" : "play.fill"
    }
}
