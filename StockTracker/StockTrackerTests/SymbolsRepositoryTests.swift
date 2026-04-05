//
//  SymbolsRepositoryTests.swift
//  StockTracker
//
//  Created by Oleksandr on 05.04.2026.
//

import Foundation
import Testing
@testable import StockTracker

@Suite("SymbolsRepository", .serialized)
struct SymbolsRepositoryTests {

    @Test("observeSymbols emits initial snapshot in original order")
    func observeSymbols_emitsInitialSnapshot() async {
        let symbols = [
            Fixtures.symbol(id: "AAPL", currentPrice: 100, previousPrice: 99),
            Fixtures.symbol(id: "NVDA", currentPrice: 900, previousPrice: 890)
        ]
        let feedService = PriceFeedServiceSpy()
        let sut = SymbolsRepository(symbols: symbols, priceFeedService: feedService)

        let stream = await sut.observeSymbols()
        guard let initial = await AsyncStreamTestHelper.next(from: stream) else {
            Issue.record("Expected initial snapshot")
            return
        }

        #expect(initial.map(\.id) == ["AAPL", "NVDA"])
        #expect(initial[0].currentPrice == 100)
        #expect(initial[1].currentPrice == 900)
    }

    @Test("startFeed forwards current snapshot to feed service")
    func startFeed_forwardsSnapshotToFeedService() async throws {
        let symbols = [
            Fixtures.symbol(id: "AAPL", currentPrice: 100, previousPrice: 99),
            Fixtures.symbol(id: "TSLA", currentPrice: 200, previousPrice: 198)
        ]
        let feedService = PriceFeedServiceSpy()
        let sut = SymbolsRepository(symbols: symbols, priceFeedService: feedService)

        try await sut.startFeed()

        let startedWith = await feedService.startedWithSymbols()
        #expect(startedWith.count == 1)
        #expect(startedWith.first?.map(\.id) == ["AAPL", "TSLA"])
    }

    @Test("incoming update mutates matching symbol and republishes snapshot")
    func incomingUpdate_updatesSymbolAndRepublishes() async throws {
        let symbols = [
            Fixtures.symbol(id: "AAPL", currentPrice: 100, previousPrice: 99),
            Fixtures.symbol(id: "NVDA", currentPrice: 900, previousPrice: 890)
        ]
        let feedService = PriceFeedServiceSpy()
        let sut = SymbolsRepository(symbols: symbols, priceFeedService: feedService)

        let stream = await sut.observeSymbols()
        _ = await AsyncStreamTestHelper.next(from: stream)

        try await sut.startFeed()
        await feedService.emit(
            update: Fixtures.update(
                symbolID: "NVDA",
                previousPrice: 900,
                currentPrice: 915,
                sequence: 1
            )
        )

        guard let updatedSnapshot = await AsyncStreamTestHelper.next(from: stream) else {
            Issue.record("Expected updated snapshot")
            return
        }

        guard let nvda = updatedSnapshot.first(where: { $0.id == "NVDA" }) else {
            Issue.record("Expected updated NVDA symbol")
            return
        }

        #expect(nvda.previousPrice == 900)
        #expect(nvda.currentPrice == 915)
    }

    @Test("incoming connection state updates repository state and republishes it")
    func incomingConnectionState_updatesAndRepublishes() async throws {
        let symbols = [Fixtures.symbol(id: "AAPL")]
        let feedService = PriceFeedServiceSpy()
        let sut = SymbolsRepository(symbols: symbols, priceFeedService: feedService)

        let stream = await sut.observeConnectionState()

        let initial = await AsyncStreamTestHelper.next(from: stream)
        #expect(initial == .stopped)

        try await sut.startFeed()
        await feedService.emit(connectionState: .connected)

        let updated = await AsyncStreamTestHelper.next(from: stream)
        #expect(updated == .connected)

        let currentState = await sut.currentConnectionState()
        #expect(currentState == .connected)
    }

    @Test("stopFeed delegates stop to feed service")
    func stopFeed_delegatesStop() async {
        let symbols = [Fixtures.symbol(id: "AAPL")]
        let feedService = PriceFeedServiceSpy()
        let sut = SymbolsRepository(symbols: symbols, priceFeedService: feedService)

        await sut.stopFeed()

        let stopCallCount = await feedService.stopCallCount()
        #expect(stopCallCount == 1)
    }
}

// MARK:  -  PriceFeedServiceSpy  -  -

actor PriceFeedServiceSpy: PriceFeedService {
    private var startedWithStorage: [[StockSymbol]] = []
    private var stopCallCountStorage = 0

    private var updatesContinuation: AsyncStream<PriceUpdate>.Continuation?
    private var connectionContinuation: AsyncStream<FeedConnectionState>.Continuation?

    func observeUpdates() -> AsyncStream<PriceUpdate> {
        AsyncStream { continuation in
            self.storeUpdatesContinuation(continuation)
        }
    }

    func observeConnectionState() -> AsyncStream<FeedConnectionState> {
        AsyncStream { continuation in
            self.storeConnectionContinuation(continuation)
        }
    }

    func start(with symbols: [StockSymbol]) async throws {
        startedWithStorage.append(symbols)
    }

    func stop() async {
        stopCallCountStorage += 1
    }

    func emit(update: PriceUpdate) {
        updatesContinuation?.yield(update)
    }

    func emit(connectionState: FeedConnectionState) {
        connectionContinuation?.yield(connectionState)
    }

    func startedWithSymbols() -> [[StockSymbol]] {
        startedWithStorage
    }

    func stopCallCount() -> Int {
        stopCallCountStorage
    }
}

// MARK:  -  Private  -  -

private extension PriceFeedServiceSpy {
    func storeUpdatesContinuation(
        _ continuation: AsyncStream<PriceUpdate>.Continuation
    ) {
        updatesContinuation = continuation
    }

    func storeConnectionContinuation(
        _ continuation: AsyncStream<FeedConnectionState>.Continuation
    ) {
        connectionContinuation = continuation
    }
}
