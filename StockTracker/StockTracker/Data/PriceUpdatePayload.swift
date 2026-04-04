//
//  PriceUpdatePayload.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  PriceUpdatePayload  -  -

struct PriceUpdatePayload: Codable, Sendable, Equatable {
    let symbolID: String
    let previousPrice: Double
    let currentPrice: Double
    let sequence: Int
    let emittedAt: Date
}
