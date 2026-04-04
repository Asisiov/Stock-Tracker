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
            return "Connected"
        case .disconnected:
            return "Disconnected"
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
