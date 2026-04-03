//
//  StockSymbol.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation

struct StockSymbol: Identifiable, Hashable, Codable {
    var id: String { ticker }

    let ticker: String
    let name: String
    let details: String
    let previousPrice: Decimal
    let currentPrice: Decimal
    let currencyCode: String
    
    var delta: Decimal { currentPrice - previousPrice }
}
