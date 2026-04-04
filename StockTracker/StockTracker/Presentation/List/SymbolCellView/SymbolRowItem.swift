//
//  SymbolRowItem.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  SymbolRowItem  -  -

struct SymbolRowItem: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let price: String
    let priceDelta: String
    let tone: SymbolBadgeStyle.Tone
}

extension SymbolRowItem {
    static var previewPositive: Self {
        Self(id: "aapl",
             title: "AAPL",
             subtitle: "Apple Inc.",
             price: "140.00",
             priceDelta: "+0.01",
             tone: .positive)
    }
    
    static var previewNegative: Self {
        Self(id: "aapl",
             title: "AAPL",
             subtitle: "Apple Inc.",
             price: "140.00",
             priceDelta: "-0.01",
             tone: .negative)
    }
}
