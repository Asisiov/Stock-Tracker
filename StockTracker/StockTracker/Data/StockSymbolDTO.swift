//
//  StockSymbolDTO.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation

struct StockSymbolDTO: Decodable {
    let ticker: String
    let name: String
    let details: String
    let previousPrice: Decimal
    let currentPrice: Decimal

    func toDomain() -> StockSymbol {
        StockSymbol(ticker: ticker,
                    name: name,
                    details: details,
                    previousPrice: previousPrice,
                    currentPrice: currentPrice)
    }
}
