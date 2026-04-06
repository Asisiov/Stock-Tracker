//
//  SymbolPresentationSnapshot.swift
//  StockTracker
//
//  Created by Oleksandr on 06.04.2026.
//

import Foundation

// MARK:  -  SymbolPresentationSnapshot  -  -

struct SymbolPresentationSnapshot: Equatable {
    let symbolID: String
    let ticker: String
    let companyName: String
    let aboutText: String
    let priceText: String
    let changeText: String
    let tone: SymbolBadgeStyle.Tone
}
