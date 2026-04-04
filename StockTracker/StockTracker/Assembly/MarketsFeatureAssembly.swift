//
//  MarketsFeatureAssembly.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  MarketsFeatureAssembly  -  -

enum MarketsFeatureAssembly {
    @MainActor
    static func makeSymbolsListView(onSelectSymbol: @escaping (String) -> Void) -> SymbolsListView {
        let symbolsLoader = SymbolsJSONLoader()
        var initialSymbols = [StockSymbol]()
        
        do {
            initialSymbols = try symbolsLoader.loadSymbols()
        } catch {
            print("Json loader failed...")
        }

        let webSocketClient = URLSessionWebSocketClient(
            url: URL(string: "wss://ws.postman-echo.com/raw")!
        )

        let priceFeedService = EchoPriceFeedService(
            webSocketClient: webSocketClient
        )

        let repository = SymbolsRepository(
            symbols: initialSymbols,
            priceFeedService: priceFeedService
        )

        let priceFormatter = PriceFormatter(locale: Locale(identifier: "en_US"))
        let priceChangeFormatter = PriceChangeFormatter(locale: Locale(identifier: "en_US"))

        let viewModel = SymbolsListViewModel(
            repository: repository,
            priceFormatter: priceFormatter,
            priceChangeFormatter: priceChangeFormatter
        )

        return SymbolsListView(viewModel: viewModel, onSelectSymbol: onSelectSymbol)
    }
}
