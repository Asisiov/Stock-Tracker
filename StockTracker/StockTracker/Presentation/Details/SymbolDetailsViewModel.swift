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
    var isFeedRunning: Bool
    var isPerformingFeedAction = false
    var connectionStatus: ConnectionStatus
    
    private var togleFeedTask: Task<Void, Never>?
    
    init(
        symbolID: String,
        ticker: String,
        companyName: String,
        priceText: String,
        changeText: String,
        tone: SymbolBadgeStyle.Tone,
        aboutText: String,
        isFeedRunning: Bool = false,
        connectionStatus: ConnectionStatus
    ) {
        self.symbolID = symbolID
        self.ticker = ticker
        self.companyName = companyName
        self.priceText = priceText
        self.changeText = changeText
        self.tone = tone
        self.aboutText = aboutText
        self.isFeedRunning = isFeedRunning
        self.connectionStatus = connectionStatus
    }
    
    var feedTitle: String {
        "Live Price Feed"
    }
    
    var feedDescriptionText: String {
        isFeedRunning
        ? "Feed is running for this symbol."
        : "Start the feed to see live prices."
    }
    
    var feedButtonTitle: String {
        isFeedRunning ? "Stop Feed" : "Start Feed"
    }
    
    var feedButtonIconName: String {
        isFeedRunning ? "stop.fill" : "play.fill"
    }
    
    func onFeedButtonTap() {
        togleFeedTask?.cancel()
        togleFeedTask = Task {
            guard !Task.isCancelled else { return }
            await toggleFeed()
        }
    }
    
    private func toggleFeed() async {
        guard !isPerformingFeedAction else { return }
        
        isPerformingFeedAction = true
        defer { isPerformingFeedAction = false }
        
        if isFeedRunning {
            isFeedRunning = false
            connectionStatus = .disconnected
            return
        }
        
        isFeedRunning = true
        connectionStatus = .connected
    }
}
