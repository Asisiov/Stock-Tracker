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
    
    var title: String {
        switch self {
        case .price: return String(localized: LocalizedStrings.SortOption.price)
        case .priceChange: return String(localized: LocalizedStrings.SortOption.change)
        }
    }
    
    var iconName: String {
        switch self {
        case .price: return AppIcon.chartLineUpTrendX
        case .priceChange: return AppIcon.sort
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
