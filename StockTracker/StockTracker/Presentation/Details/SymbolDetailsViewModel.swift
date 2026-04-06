//
//  SymbolDetailsViewModel.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import SwiftUI

@MainActor
@Observable
final class SymbolDetailsViewModel {
    let symbolID: String
    let ticker: String
    let companyName: String
    let aboutText: String
    
    var priceText: String
    var changeText: String
    var tone: SymbolBadgeStyle.Tone
    var connectionStatus: ConnectionStatus
    
    init(
        symbolID: String,
        ticker: String,
        companyName: String,
        priceText: String,
        changeText: String,
        tone: SymbolBadgeStyle.Tone,
        aboutText: String,
        connectionStatus: ConnectionStatus
    ) {
        self.symbolID = symbolID
        self.ticker = ticker
        self.companyName = companyName
        self.priceText = priceText
        self.changeText = changeText
        self.tone = tone
        self.aboutText = aboutText
        self.connectionStatus = connectionStatus
    }
}
