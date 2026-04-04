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
    let previousPrice: Decimal
    let currentPrice: Decimal
    let sequence: Int
    let emittedAt: Date
}

// MARK:  -  PriceUpdate  -  -

struct PriceUpdate: Sendable, Equatable {
    let symbolID: String
    let previousPrice: Decimal
    let currentPrice: Decimal
    let sequence: Int
    let emittedAt: Date

    var delta: Decimal {
        currentPrice - previousPrice
    }
}
