//
//  SymbolSortOption.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import Foundation

enum SymbolSortOption: String, CaseIterable, Codable {
    case price
    case priceChange
    
    // TODO: Localisation
    var title: String {
        switch self {
        case .price: return "Price"
        case .priceChange: return "% Change"
        }
    }
    
    var iconName: String {
        switch self {
        case .price: return "chart.line.uptrend.xyaxis"
        case .priceChange: return "arrow.up.arrow.down"
        }
    }
}

extension SymbolSortOption {
    func comparator(lhs: StockSymbol, rhs: StockSymbol) -> Bool {
        switch self {
        case .price:
            if lhs.currentPrice != rhs.currentPrice {
                return lhs.currentPrice > rhs.currentPrice
            }
            return lhs.ticker < rhs.ticker
            
        case .priceChange:
            if lhs.delta != rhs.delta {
                return lhs.delta > rhs.delta
            }
            return lhs.ticker < rhs.ticker
        }
    }
}
