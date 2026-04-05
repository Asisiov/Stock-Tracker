//
//  EchoPriceFeedServiceTests.swift
//  StockTracker
//
//  Created by Oleksandr on 05.04.2026.
//

import Foundation
import Testing
@testable import StockTracker

@Suite("EchoPriceFeedService", .serialized)
struct EchoPriceFeedServiceTests {

    @Test("echoed payload is decoded and published as PriceUpdate")
    func echoedPayload_isPublishedAsUpdate() async throws {
        let webSocket = WebSocketClientSpy()
        await webSocket.enqueueReceivedText(
            Fixtures.payloadJSON(
                symbolID: "AAPL",
                previousPrice: 100,
                currentPrice: 101.5,
                sequence: 7,
                emittedAt: "2026-04-05T10:00:00Z"
            )
        )

        let sut = EchoPriceFeedService(
            webSocketClient: webSocket,
            updateInterval: 60,
            randomDeltaProvider: { 1.0 }
        )

        let updates = await sut.observeUpdates()

        try await sut.start(with: [
            Fixtures.symbol(id: "AAPL", currentPrice: 100, previousPrice: 99)
        ])

        guard let update = await AsyncStreamTestHelper.next(from: updates) else {
            Issue.record("Expected decoded update")
            return
        }

        #expect(update.symbolID == "AAPL")
        #expect(update.previousPrice == 100)
        #expect(update.currentPrice == 101.5)
        #expect(update.sequence == 7)
    }

    @Test("stop moves state to stopped and disconnects socket")
    func stop_movesStateToStoppedAndDisconnects() async throws {
        let webSocket = WebSocketClientSpy()
        let sut = EchoPriceFeedService(
            webSocketClient: webSocket,
            updateInterval: 60,
            randomDeltaProvider: { 0.5 }
        )

        let states = await sut.observeConnectionState()
        _ = await AsyncStreamTestHelper.next(from: states)

        try await sut.start(with: [
            Fixtures.symbol(id: "AAPL", currentPrice: 100, previousPrice: 99)
        ])
        _ = await AsyncStreamTestHelper.next(from: states)

        await sut.stop()

        let stopped = await AsyncStreamTestHelper.next(from: states)
        #expect(stopped == .stopped)

        let disconnectCount = await webSocket.disconnectCount()
        #expect(disconnectCount == 1)
    }

    @Test("receive failure moves state to disconnected and disconnects socket")
    func receiveFailure_movesStateToDisconnected() async throws {
        let webSocket = WebSocketClientSpy()
        await webSocket.enqueueReceiveError(WebSocketSpyError.forcedFailure)

        let sut = EchoPriceFeedService(
            webSocketClient: webSocket,
            updateInterval: 60,
            randomDeltaProvider: { 1.0 }
        )

        let states = await sut.observeConnectionState()

        let initial = await AsyncStreamTestHelper.next(from: states)
        #expect(initial == .stopped)

        try await sut.start(with: [
            Fixtures.symbol(id: "AAPL", currentPrice: 100, previousPrice: 99)
        ])

        let connected = await AsyncStreamTestHelper.next(from: states)
        #expect(connected == .connected)

        let disconnected = await AsyncStreamTestHelper.next(from: states)
        #expect(disconnected == .disconnected)

        let disconnectCount = await webSocket.disconnectCount()
        #expect(disconnectCount == 1)
    }
}

// MARK:  -  WebSocketClientSpy  -  -

actor WebSocketClientSpy: WebSocketClient {
    private var connectCountStorage = 0
    private var disconnectCountStorage = 0
    private var sentTextsStorage: [String] = []

    private var connectError: Error?
    private var sendError: Error?

    private var queuedReceiveResults: [Result<String, Error>] = []
    private var waitingReceivers: [CheckedContinuation<String, Error>] = []

    func connect() async throws {
        if let connectError {
            throw connectError
        }

        connectCountStorage += 1
    }

    func send(text: String) async throws {
        if let sendError {
            throw sendError
        }

        sentTextsStorage.append(text)
    }

    func receive() async throws -> String {
        if queuedReceiveResults.isEmpty == false {
            return try queuedReceiveResults.removeFirst().get()
        }

        return try await withCheckedThrowingContinuation { continuation in
            waitingReceivers.append(continuation)
        }
    }

    func disconnect() async {
        disconnectCountStorage += 1

        let receivers = waitingReceivers
        waitingReceivers.removeAll()

        receivers.forEach { $0.resume(throwing: CancellationError()) }
    }

    func enqueueReceivedText(_ text: String) {
        if waitingReceivers.isEmpty == false {
            let continuation = waitingReceivers.removeFirst()
            continuation.resume(returning: text)
            return
        }

        queuedReceiveResults.append(.success(text))
    }

    func enqueueReceiveError(_ error: Error) {
        if waitingReceivers.isEmpty == false {
            let continuation = waitingReceivers.removeFirst()
            continuation.resume(throwing: error)
            return
        }

        queuedReceiveResults.append(.failure(error))
    }

    func connectCount() -> Int {
        connectCountStorage
    }

    func disconnectCount() -> Int {
        disconnectCountStorage
    }

    func sentTexts() -> [String] {
        sentTextsStorage
    }
}

// MARK:  -  WebSocketSpyError  -  -

enum WebSocketSpyError: Error {
    case forcedFailure
}
