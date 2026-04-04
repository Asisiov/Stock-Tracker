//
//  SymbolsListViewModel.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

enum SymbolsListState: Equatable {
    case idle
    case loading
    case content([SymbolCellViewModel])
    case empty
    case failed
}

@MainActor
@Observable
final class SymbolsListViewModel {
    
    private(set) var state: SymbolsListState = .idle
    private(set) var connectionStatus: ConnectionStatus = .disconnected
    
    var sortOption: SymbolSortOption = .price {
        didSet {
            guard oldValue != sortOption else { return }
            rebuildCells()
        }
    }
    
    private var symbols: [StockSymbol] = []
    
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
        guard state != .loading else { return }
        state = .loading
        
        do {
            symbols = try await loader.loadSymbols()
            rebuildCells()
        } catch {
            symbols = []
            state = .failed
        }
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
        guard symbols.isEmpty == false else {
            state = .empty
            return
        }
        
        let sortedSymbols = sort(symbols, by: sortOption)
        let items = sortedSymbols.map { symbol in
            let price = priceFormatter.string(from: symbol.currentPrice, currencyCode: symbol.currencyCode)
            let priceDelta = priceChangeFormatter.string(from: symbol.delta, currencyCode: symbol.currencyCode)
            
            return SymbolCellViewModel(
                title: symbol.ticker,
                subtitle: symbol.name,
                price: price,
                priceDelta: priceDelta,
                tone: .positive
            )
        }
        
        state = .content(items)
    }
    
    private func sort(_ symbols: [StockSymbol], by option: SymbolSortOption) -> [StockSymbol] {
        symbols.sorted { option.comparator(lhs: $0, rhs: $1) }
    }
}

extension SymbolsListViewModel {
    static func build(locale: Locale = Locale(identifier: "en_US")) -> SymbolsListViewModel {
        SymbolsListViewModel(priceFormatter: PriceFormatter(locale: locale),
                             priceChangeFormatter: PriceChangeFormatter(locale: locale),
                             loader: SymbolsJSONLoader())
    }
}
