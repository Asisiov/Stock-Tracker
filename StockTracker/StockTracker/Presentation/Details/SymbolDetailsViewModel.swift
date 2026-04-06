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
        snapshot: SymbolPresentationSnapshot,
        connectionStatus: ConnectionStatus
    ) {
        self.symbolID = snapshot.symbolID
        self.ticker = snapshot.ticker
        self.companyName = snapshot.companyName
        self.aboutText = snapshot.aboutText
        self.priceText = snapshot.priceText
        self.changeText = snapshot.changeText
        self.tone = snapshot.tone
        self.connectionStatus = connectionStatus
    }
    
    func update(
        with snapshot: SymbolPresentationSnapshot,
        connectionStatus: ConnectionStatus
    ) {
        guard snapshot.symbolID == symbolID else {
            assertionFailure("Attempted to update details view model with a different symbol.")
            return
        }
        
        priceText = snapshot.priceText
        changeText = snapshot.changeText
        tone = snapshot.tone
        self.connectionStatus = connectionStatus
    }
    
    func updateConnectionStatus(_ status: ConnectionStatus) {
        connectionStatus = status
    }
}
