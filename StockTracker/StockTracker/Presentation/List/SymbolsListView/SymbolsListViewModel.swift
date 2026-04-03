//
//  SymbolsListViewModel.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

@MainActor
@Observable
final class SymbolsListViewModel {
    var cellViewModels: [SymbolCellViewModel] = []
    private var symbols: [StockSymbol] = []
    private(set) var sortOption: SymbolSortOption = .price
    
    var error: Error?
    
    let priceFormatter: PriceFormatting
    let priceChangeFormatter: PriceChangeFormatting
    let loader: SymbolsLoading
    
    init(priceFormatter: PriceFormatting,
         priceChangeFormatter: PriceChangeFormatting,
         loader: SymbolsLoading) {
        self.priceFormatter = priceFormatter
        self.priceChangeFormatter = priceChangeFormatter
        self.loader = loader
    }
    
    func loadStocks() async {
        do {
            symbols = try await loader.loadSymbols()
            rebuildCells()
        } catch {
            self.error = error
        }
    }
    
    func setSortOption(_ option: SymbolSortOption) {
        guard sortOption != option else { return }
        sortOption = option
        rebuildCells()
    }
    
    private func tone(for price: Decimal) -> SymbolBadgeStyle.Tone {
        if price > 0 {
            return .positive
        } else if price < 0 {
            return .negative
        } else {
            return .neutral
        }
    }
    
    private func rebuildCells() {
        let sortedSymbols = sort(symbols, by: sortOption)
        cellViewModels = sortedSymbols.map { symbol in
            let price = priceFormatter.string(from: symbol.currentPrice)
            let priceDelta = priceChangeFormatter.string(from: symbol.delta)
            
            return SymbolCellViewModel(
                title: symbol.ticker,
                subtitle: symbol.name,
                price: price,
                priceDelta: priceDelta,
                tone: .positive
            )
        }
    }
    
    private func sort(_ symbols: [StockSymbol], by option: SymbolSortOption) -> [StockSymbol] {
        symbols.sorted { option.comparator(lhs: $0, rhs: $1) }
    }
}

extension SymbolsListViewModel {
    static func build() -> SymbolsListViewModel {
        SymbolsListViewModel(priceFormatter: PriceFormatter(locale: .current),
                             priceChangeFormatter: PriceChangeFormatter(locale: .current),
                             loader: SymbolsJSONLoader())
    }
}
