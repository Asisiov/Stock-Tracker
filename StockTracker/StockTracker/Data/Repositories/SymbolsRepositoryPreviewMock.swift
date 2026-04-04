//
//  SymbolsRepositoryPreviewMock.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  SymbolsRepositoryPreviewMock  -  -

actor SymbolsRepositoryPreviewMock: SymbolsRepositoryProtocol {
    private let symbols: [StockSymbol]
    private let connectionState: FeedConnectionState

    init(
        symbols: [StockSymbol],
        connectionState: FeedConnectionState
    ) {
        self.symbols = symbols
        self.connectionState = connectionState
    }

    func observeSymbols() async -> AsyncStream<[StockSymbol]> {
        AsyncStream { continuation in
            continuation.yield(symbols)
            continuation.finish()
        }
    }

    func observeConnectionState() async -> AsyncStream<FeedConnectionState> {
        AsyncStream { continuation in
            continuation.yield(connectionState)
            continuation.finish()
        }
    }

    func currentSymbols() async -> [StockSymbol] {
        symbols
    }

    func symbol(id: String) async -> StockSymbol? {
        symbols.first(where: { $0.id == id })
    }

    func currentConnectionState() -> FeedConnectionState {
        connectionState
    }

    func startFeed() async throws { }

    func stopFeed() async { }
}
