//
//  SymbolsRepositoryProtocol.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK: - SymbolsRepositoryProtocol

protocol SymbolsRepositoryProtocol: Actor {
    func observeSymbols() async -> AsyncStream<[StockSymbol]>
    func observeConnectionState() async -> AsyncStream<FeedConnectionState>

    func currentSymbols() async -> [StockSymbol]
    func symbol(id: String) async -> StockSymbol?
    
    func currentConnectionState() -> FeedConnectionState

    func startFeed() async throws
    func stopFeed() async
}
