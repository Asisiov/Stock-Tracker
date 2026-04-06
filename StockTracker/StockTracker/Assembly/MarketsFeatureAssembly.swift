//
//  MarketsFeatureAssembly.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import SwiftUI

// MARK:  -  MarketsFeatureAssembly  -  -

enum MarketsFeatureAssembly {
    @MainActor
    static func makeCoordinatorView() -> some View {
        let repository = makeRepository()

        let presentationMapper = SymbolPresentationMapper(
            priceFormatter: PriceFormatter(locale: .current),
            priceChangeFormatter: PriceChangeFormatter(locale: .current)
        )

        let listViewModel = SymbolsListViewModel(
            repository: repository,
            presentationMapper: presentationMapper
        )

        let coordinator = MarketsCoordinator(
            listViewModel: listViewModel
        )

        return MarketsCoordinatorView(
            coordinator: coordinator
        )
    }

    @MainActor
    static func makeSymbolsListView(
        viewModel: SymbolsListViewModel,
        onSelectSymbol: @escaping (String) -> Void
    ) -> some View {
        SymbolsListView(
            viewModel: viewModel,
            onSelectSymbol: onSelectSymbol
        )
    }
}

// MARK:  -  Private  -  -

private extension MarketsFeatureAssembly {
    @MainActor
    static func makeRepository() -> SymbolsRepositoryProtocol {
        
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
        
        return SymbolsRepository(
            symbols: initialSymbols,
            priceFeedService: priceFeedService
        )
    }
}
