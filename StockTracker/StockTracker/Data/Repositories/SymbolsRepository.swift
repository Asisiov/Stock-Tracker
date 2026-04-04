//
//  ymbolsRepository.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  SymbolsRepository  -  -

actor SymbolsRepository {
    private let priceFeedService: any PriceFeedService

    private let orderedIDs: [String]
    private var symbolsByID: [String: StockSymbol]
    private var connectionState: FeedConnectionState = .stopped

    private var symbolsObservers: [UUID: AsyncStream<[StockSymbol]>.Continuation] = [:]
    private var connectionObservers: [UUID: AsyncStream<FeedConnectionState>.Continuation] = [:]

    private var updatesBindingTask: Task<Void, Never>?
    private var connectionBindingTask: Task<Void, Never>?

    init(
        symbols: [StockSymbol],
        priceFeedService: any PriceFeedService
    ) {
        self.orderedIDs = symbols.map(\.id)
        self.symbolsByID = Dictionary(
            uniqueKeysWithValues: symbols.map { ($0.id, $0) }
        )
        self.priceFeedService = priceFeedService
    }

    func observeSymbols() -> AsyncStream<[StockSymbol]> {
        let id = UUID()

        return AsyncStream { continuation in
            Task {
                await self.addSymbolsObserver(continuation, id: id)
            }
        }
    }

    func observeConnectionState() -> AsyncStream<FeedConnectionState> {
        let id = UUID()

        return AsyncStream { continuation in
            Task {
                await self.addConnectionObserver(continuation, id: id)
            }
        }
    }

    func currentSymbols() -> [StockSymbol] {
        snapshot()
    }

    func symbol(id: String) -> StockSymbol? {
        symbolsByID[id]
    }

    func startFeed() async throws {
        await bindFeedIfNeeded()
        try await priceFeedService.start(with: snapshot())
    }

    func stopFeed() async {
        await priceFeedService.stop()
    }
}

// MARK:  -  Binding  -  -

private extension SymbolsRepository {
    func bindFeedIfNeeded() async {
        guard updatesBindingTask == nil, connectionBindingTask == nil else { return }

        updatesBindingTask = Task {
            let updates = await self.priceFeedService.observeUpdates()

            for await update in updates {
                await self.apply(update)
            }
        }

        connectionBindingTask = Task {
            let states = await self.priceFeedService.observeConnectionState()

            for await state in states {
                self.apply(state)
            }
        }
    }

    func apply(_ update: PriceUpdate) async {
        guard var symbol = symbolsByID[update.symbolID] else { return }

        symbol.previousPrice = update.previousPrice
        symbol.currentPrice = update.currentPrice

        symbolsByID[update.symbolID] = symbol
        publishSymbols()
    }

    func apply(_ state: FeedConnectionState) {
        connectionState = state
        publishConnectionState()
    }
}

// MARK:  -  Snapshot  -  -

private extension SymbolsRepository {
    func snapshot() -> [StockSymbol] {
        orderedIDs.compactMap { symbolsByID[$0] }
    }

    func publishSymbols() {
        let snapshot = snapshot()
        symbolsObservers.values.forEach { $0.yield(snapshot) }
    }

    func publishConnectionState() {
        connectionObservers.values.forEach { $0.yield(connectionState) }
    }
}

// MARK:  -  Observers  -  -

private extension SymbolsRepository {
    func addSymbolsObserver(
        _ continuation: AsyncStream<[StockSymbol]>.Continuation,
        id: UUID
    ) async {
        symbolsObservers[id] = continuation
        continuation.yield(snapshot())

        continuation.onTermination = { _ in
            Task {
                await self.removeSymbolsObserver(id: id)
            }
        }
    }

    func removeSymbolsObserver(id: UUID) async {
        symbolsObservers[id] = nil
    }

    func addConnectionObserver(
        _ continuation: AsyncStream<FeedConnectionState>.Continuation,
        id: UUID
    ) async {
        connectionObservers[id] = continuation
        continuation.yield(connectionState)

        continuation.onTermination = { _ in
            Task {
                await self.removeConnectionObserver(id: id)
            }
        }
    }

    func removeConnectionObserver(id: UUID) {
        connectionObservers[id] = nil
    }
}
