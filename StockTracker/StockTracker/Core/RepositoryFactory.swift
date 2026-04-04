//
//  RepositoryFactory.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  RepositoryFactory  -  -

enum RepositoryFactory {
    static func makeSymbolsRepository(
        symbols: [StockSymbol]
    ) -> SymbolsRepository {
        let client = URLSessionWebSocketClient(
            url: URL(string: "wss://ws.postman-echo.com/raw")!
        )

        let feedService = EchoPriceFeedService(
            webSocketClient: client,
            updateInterval: 1.0
        )

        return SymbolsRepository(
            symbols: symbols,
            priceFeedService: feedService
        )
    }
}
