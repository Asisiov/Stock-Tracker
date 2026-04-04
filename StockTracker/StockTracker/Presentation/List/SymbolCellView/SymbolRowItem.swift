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
