//
//  SymbolPresentationMapper.swift
//  StockTracker
//
//  Created by Oleksandr on 06.04.2026.
//

import Foundation

// MARK:  -  SymbolPresentationMapper  -  -

struct SymbolPresentationMapper: SymbolPresentationMapping {
    private let priceFormatter: PriceFormatting
    private let priceChangeFormatter: PriceChangeFormatting

    init(
        priceFormatter: PriceFormatting,
        priceChangeFormatter: PriceChangeFormatting
    ) {
        self.priceFormatter = priceFormatter
        self.priceChangeFormatter = priceChangeFormatter
    }

    func makeSnapshot(from symbol: StockSymbol) -> SymbolPresentationSnapshot {
        SymbolPresentationSnapshot(
            symbolID: symbol.id,
            ticker: symbol.ticker,
            companyName: symbol.name,
            aboutText: symbol.details,
            priceText: priceFormatter.string(
                from: symbol.currentPrice,
                currencyCode: symbol.currencyCode
            ),
            changeText: priceChangeFormatter.string(
                from: symbol.delta,
                currencyCode: symbol.currencyCode
            ),
            tone: tone(for: symbol.delta)
        )
    }
}

// MARK:  -  Private  -  -

private extension SymbolPresentationMapper {
    func tone(for value: Decimal) -> SymbolBadgeStyle.Tone {
        if value > 0 {
            return .positive
        } else if value < 0 {
            return .negative
        } else {
            return .neutral
        }
    }
}
