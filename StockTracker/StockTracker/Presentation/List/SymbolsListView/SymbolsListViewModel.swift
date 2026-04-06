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
    
    private(set) var detailsViewModel: SymbolDetailsViewModel?
    private(set) var selectedSymbolID: String?
    
    var isShowingDetails: Bool {
        detailsViewModel != nil
    }
    
    private var symbols: [StockSymbol] = []
    private var hasStarted = false
    
    private var symbolsTask: Task<Void, Never>?
    private var connectionTask: Task<Void, Never>?
    private var toggleFeedTask: Task<Void, Never>?
    
    private let repository: SymbolsRepositoryProtocol
    private let presentationMapper: SymbolPresentationMapping
    
    init(repository: SymbolsRepositoryProtocol,
         presentationMapper: SymbolPresentationMapping) {
        self.repository = repository
        self.presentationMapper = presentationMapper
    }
    
    isolated deinit {
        symbolsTask?.cancel()
        connectionTask?.cancel()
        toggleFeedTask?.cancel()
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
        toggleFeedTask?.cancel()
        toggleFeedTask = Task {
            guard !Task.isCancelled else { return }
            await toggleFeed()
        }
    }
    
    func selectSymbol(id: String) {
//        guard selectedSymbolID != id else { return }
        guard let symbol = symbols.first(where: { $0.id == id }) else { return }
        selectedSymbolID = id
        
        let snapshot = presentationMapper.makeSnapshot(from: symbol)        
        if let detailsViewModel,
           detailsViewModel.symbolID == id {
            detailsViewModel.update(
                with: snapshot,
                connectionStatus: connectionStatus
            )
        } else {
            detailsViewModel = SymbolDetailsViewModel(
                snapshot: snapshot,
                connectionStatus: connectionStatus
            )
        }
    }
    
    func clearSelection() {
        selectedSymbolID = nil
        detailsViewModel = nil
    }
}

// MARK:  -  Private  -  -

private extension SymbolsListViewModel {
    func observeSymbols() async {
        let initial = await repository.currentSymbols()
        symbols = initial
        rebuildState()
        syncSelectedDetails()

        let stream = await repository.observeSymbols()
        for await symbols in stream {
            guard Task.isCancelled == false else { return }
            self.symbols = symbols
            rebuildState()
            syncSelectedDetails()
        }
    }

    func observeConnectionStatus() async {
        let state = await repository.currentConnectionState()
        connectionStatus = mapFeedSate(state)
        detailsViewModel?.updateConnectionStatus(connectionStatus)

        let stream = await repository.observeConnectionState()
        for await state in stream {
            guard Task.isCancelled == false else { return }
            connectionStatus = mapFeedSate(state)
            detailsViewModel?.updateConnectionStatus(connectionStatus)
        }
    }

    func rebuildState() {
        guard symbols.isEmpty == false else {
            state = .empty
            return
        }

        let items = sort(symbols, by: sortOption).map { symbol in
            let snapshot = presentationMapper.makeSnapshot(from: symbol)
            return makeRowItem(from: snapshot)
        }
        state = .content(items)
    }

    func sort(_ symbols: [StockSymbol], by option: SymbolSortOption) -> [StockSymbol] {
        symbols.sorted { option.comparator(lhs: $0, rhs: $1) }
    }

    func makeRowItem(from snapshot: SymbolPresentationSnapshot) -> SymbolRowItem {
        SymbolRowItem(
            id: snapshot.symbolID,
            title: snapshot.ticker,
            subtitle: snapshot.companyName,
            price: snapshot.priceText,
            priceDelta: snapshot.changeText,
            tone: snapshot.tone
        )
    }
    
    func mapFeedSate(_ state: FeedConnectionState) -> ConnectionStatus {
        state == .connected ? .connected : .disconnected
    }
    
    func syncSelectedDetails() {
        guard let selectedSymbolID else {
            detailsViewModel = nil
            return
        }
        
        guard let symbol = symbols.first(where: { $0.id == selectedSymbolID }) else {
            clearSelection()
            return
        }
        
        let snapshot = presentationMapper.makeSnapshot(from: symbol)
        
        if let detailsViewModel {
            detailsViewModel.update(
                with: snapshot,
                connectionStatus: connectionStatus
            )
        } else {
            detailsViewModel = SymbolDetailsViewModel(
                snapshot: snapshot,
                connectionStatus: connectionStatus
            )
        }
    }
}
