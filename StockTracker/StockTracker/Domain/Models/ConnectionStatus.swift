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
}
