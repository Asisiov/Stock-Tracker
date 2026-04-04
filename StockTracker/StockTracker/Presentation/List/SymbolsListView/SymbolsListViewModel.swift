//
//  SymbolsListViewModel.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

// MARK: - SymbolsListState - -

enum SymbolsListState: Equatable {
    case idle
    case loading
    case content([SymbolRowItem])
    case empty
    case failed
}

// MARK: - SymbolsListViewModel - -

@MainActor
@Observable
final class SymbolsListViewModel {
    
    private(set) var state: SymbolsListState = .idle
    private(set) var connectionStatus: ConnectionStatus = .disconnected {
        didSet {
            guard connectionStatus == .disconnected else { return }
            hasStarted = false
        }
    }
    private(set) var isPerformingFeedAction = false
    
    var sortOption: SymbolSortOption = .price {
        didSet {
            guard oldValue != sortOption else { return }
            rebuildState()
        }
    }
    
    private var symbols: [StockSymbol] = []
    private var hasStarted = false
    
    private var symbolsTask: Task<Void, Never>?
    private var connectionTask: Task<Void, Never>?
    private var togleFeedTask: Task<Void, Never>?
    
    private let repository: SymbolsRepositoryProtocol
    private let priceFormatter: PriceFormatting
    private let priceChangeFormatter: PriceChangeFormatting
    
    init(repository: SymbolsRepositoryProtocol,
         priceFormatter: PriceFormatting,
         priceChangeFormatter: PriceChangeFormatting) {
        self.repository = repository
        self.priceFormatter = priceFormatter
        self.priceChangeFormatter = priceChangeFormatter
    }
    
    isolated deinit {
        symbolsTask?.cancel()
        connectionTask?.cancel()
        togleFeedTask?.cancel()
    }
    
    func onTask() {
        guard hasStarted == false else { return }
        hasStarted = true
        
        state = .loading
        
        symbolsTask?.cancel()
        symbolsTask = Task { [weak self] in
            guard let self else { return }
            guard Task.isCancelled == false else { return }
            await self.observeSymbols()
        }
        
        connectionTask?.cancel()
        connectionTask = Task { [weak self] in
            guard let self else { return }
            guard Task.isCancelled == false else { return }
            await self.observeConnectionStatus()
        }
    }
    
    func toggleFeed() async {
        guard isPerformingFeedAction == false else { return }
        
        isPerformingFeedAction = true
        defer { isPerformingFeedAction = false }
        
        do {
            switch connectionStatus {
            case .connected:
                await repository.stopFeed()
                
            case .disconnected:
                try await repository.startFeed()
            }
        } catch {
            state = .failed
        }
    }
    
    func onFeedButtonTap() {
        togleFeedTask?.cancel()
        togleFeedTask = Task {
            guard !Task.isCancelled else { return }
            await toggleFeed()
        }
    }
}

// MARK:  -  Private  -  -

private extension SymbolsListViewModel {
    func observeSymbols() async {
        let initial = await repository.currentSymbols()
        symbols = initial
        rebuildState()

        let stream = await repository.observeSymbols()
        for await symbols in stream {
            guard Task.isCancelled == false else { return }
            self.symbols = symbols
            rebuildState()
        }
    }

    func observeConnectionStatus() async {
        let state = await repository.currentConnectionState()
        connectionStatus = mapFeedSate(state)

        let stream = await repository.observeConnectionState()
        for await state in stream {
            guard Task.isCancelled == false else { return }
            connectionStatus = mapFeedSate(state)
        }
    }

    func rebuildState() {
        guard symbols.isEmpty == false else {
            state = .empty
            return
        }

        let items = sort(symbols, by: sortOption).map(makeRowItem(from:))
        state = .content(items)
    }

    func sort(_ symbols: [StockSymbol], by option: SymbolSortOption) -> [StockSymbol] {
        symbols.sorted { option.comparator(lhs: $0, rhs: $1) }
    }

    func makeRowItem(from symbol: StockSymbol) -> SymbolRowItem {
        SymbolRowItem(
            id: symbol.id,
            title: symbol.ticker,
            subtitle: symbol.name,
            price: priceFormatter.string(from: symbol.currentPrice, currencyCode: symbol.currencyCode),
            priceDelta: priceChangeFormatter.string(from: symbol.delta, currencyCode: symbol.currencyCode),
            tone: tone(for: symbol.delta)
        )
    }

    func tone(for value: Decimal) -> SymbolBadgeStyle.Tone {
        if value > 0 {
            return .positive
        } else if value < 0 {
            return .negative
        } else {
            return .neutral
        }
    }
    
    func mapFeedSate(_ state: FeedConnectionState) -> ConnectionStatus {
        state == .connected ? .connected : .disconnected
    }
}
