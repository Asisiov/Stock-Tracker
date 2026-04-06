//
//  SymbolsListPreviewFactory.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  SymbolsListPreviewFactory  -  -

enum SymbolsListPreviewFactory {
    @MainActor
    static func make(
        connectionState: FeedConnectionState
    ) -> SymbolsListViewModel {
        let repository = SymbolsRepositoryPreviewMock(
            symbols: StockSymbol.previewList,
            connectionState: connectionState
        )

        let priceFormatter = PriceFormatter(locale: Locale(identifier: "en_US"))
        let priceChangeFormatter = PriceChangeFormatter(locale: Locale(identifier: "en_US"))

        let presentationMapper = SymbolPresentationMapper(
            priceFormatter: priceFormatter,
            priceChangeFormatter: priceChangeFormatter
        )

        return SymbolsListViewModel(
            repository: repository,
            presentationMapper: presentationMapper
        )
    }
}

extension StockSymbol {
    static let previewList: [StockSymbol] = [
        StockSymbol(
            ticker: "AAPL",
            name: "Apple Inc.",
            details: "Apple designs consumer electronics, software and services.",
            previousPrice: 212.14,
            currentPrice: 214.83,
            currencyCode: "USD"
        ),
        StockSymbol(
            ticker: "NVDA",
            name: "NVIDIA Corporation",
            details: "NVIDIA builds GPUs, AI computing platforms and related software.",
            previousPrice: 118.02,
            currentPrice: 116.41,
            currencyCode: "USD"
        ),
        StockSymbol(
            ticker: "MSFT",
            name: "Microsoft Corporation",
            details: "Microsoft develops software, cloud services and devices.",
            previousPrice: 428.11,
            currentPrice: 428.11,
            currencyCode: "USD"
        ),
        StockSymbol(
            ticker: "TSLA",
            name: "Tesla, Inc.",
            details: "Tesla designs and manufactures electric vehicles and energy systems.",
            previousPrice: 171.42,
            currentPrice: 176.07,
            currencyCode: "USD"
        )
    ]
}
