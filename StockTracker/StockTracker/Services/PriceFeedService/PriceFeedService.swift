//
//  PriceFeedService.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  FeedConnectionState  -  -

enum FeedConnectionState: Sendable, Equatable {
    case stopped
    case connected
    case disconnected
}


// MARK:  -  PriceFeedService  -  -

protocol PriceFeedService: Actor {
    func observeUpdates() -> AsyncStream<PriceUpdate>
    func observeConnectionState() -> AsyncStream<FeedConnectionState>

    func start(with symbols: [StockSymbol]) async throws
    func stop() async
}
