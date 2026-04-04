//
//  EchoPriceFeedService.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  EchoPriceFeedService  -  -

actor EchoPriceFeedService: PriceFeedService {
    private let webSocketClient: any WebSocketClient
    private let updateIntervalNanoseconds: UInt64
    private let randomDeltaProvider: @Sendable () -> Decimal

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private var trackedPrices: [String: Decimal] = [:]
    private var sequence: Int = 0
    private var connectionState: FeedConnectionState = .stopped

    private var sendTask: Task<Void, Never>?
    private var receiveTask: Task<Void, Never>?

    private var updateObservers: [UUID: AsyncStream<PriceUpdate>.Continuation] = [:]
    private var connectionObservers: [UUID: AsyncStream<FeedConnectionState>.Continuation] = [:]

    init(
        webSocketClient: any WebSocketClient,
        updateInterval: TimeInterval = 1.0,
        randomDeltaProvider: @escaping @Sendable () -> Decimal = {
            Decimal(Double.random(in: -1.50 ... 1.50))
        }
    ) {
        self.webSocketClient = webSocketClient
        self.updateIntervalNanoseconds = UInt64(updateInterval * 1_000_000_000)
        self.randomDeltaProvider = randomDeltaProvider

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func observeUpdates() -> AsyncStream<PriceUpdate> {
        let id = UUID()

        return AsyncStream { continuation in
            Task {
                await self.addUpdateObserver(continuation, id: id)
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

    func start(with symbols: [StockSymbol]) async throws {
        guard sendTask == nil, receiveTask == nil else { return }
        guard symbols.isEmpty == false else { return }

        trackedPrices = Dictionary(
            uniqueKeysWithValues: symbols.map { ($0.id, $0.currentPrice) }
        )

        try await webSocketClient.connect()
        setConnectionState(.connected)

        sendTask = Task {
            await self.runSendLoop()
        }

        receiveTask = Task {
            await self.runReceiveLoop()
        }
    }

    func stop() async {
        guard connectionState != .stopped else { return }

        setConnectionState(.stopped)

        sendTask?.cancel()
        receiveTask?.cancel()

        sendTask = nil
        receiveTask = nil

        await webSocketClient.disconnect()
    }
}

// MARK:  -  Private  -  -

private extension EchoPriceFeedService {
    func runSendLoop() async {
        do {
            while Task.isCancelled == false {
                let payload = try makeNextPayload()
                let message = try encode(payload)

                try await webSocketClient.send(text: message)
                try await Task.sleep(nanoseconds: updateIntervalNanoseconds)
            }
        } catch is CancellationError {
            return
        } catch {
            await handleTransportFailure()
        }
    }

    func runReceiveLoop() async {
        do {
            while Task.isCancelled == false {
                let message = try await webSocketClient.receive()
                let update = try decodeUpdate(from: message)

                publish(update)
            }
        } catch is CancellationError {
            return
        } catch {
            await handleTransportFailure()
        }
    }

    func makeNextPayload() throws -> PriceUpdatePayload {
        guard let symbolID = trackedPrices.keys.randomElement(),
              let previousPrice = trackedPrices[symbolID] else {
            throw WebSocketClientError.invalidTextPayload
        }

        sequence += 1

        let currentPrice = max(
            0.01,
            (previousPrice + randomDeltaProvider()).roundedToTwoDecimals()
        )

        trackedPrices[symbolID] = currentPrice

        return PriceUpdatePayload(
            symbolID: symbolID,
            previousPrice: previousPrice,
            currentPrice: currentPrice,
            sequence: sequence,
            emittedAt: Date()
        )
    }

    func encode(_ payload: PriceUpdatePayload) throws -> String {
        let data = try encoder.encode(payload)

        guard let text = String(data: data, encoding: .utf8) else {
            throw WebSocketClientError.invalidTextPayload
        }

        return text
    }

    func decodeUpdate(from text: String) throws -> PriceUpdate {
        let payload = try decoder.decode(
            PriceUpdatePayload.self,
            from: Data(text.utf8)
        )

        return PriceUpdate(
            symbolID: payload.symbolID,
            previousPrice: payload.previousPrice,
            currentPrice: payload.currentPrice,
            sequence: payload.sequence,
            emittedAt: payload.emittedAt
        )
    }

    func handleTransportFailure() async {
        guard connectionState != .stopped else { return }

        sendTask?.cancel()
        receiveTask?.cancel()

        sendTask = nil
        receiveTask = nil

        await webSocketClient.disconnect()
        setConnectionState(.disconnected)
    }

    func publish(_ update: PriceUpdate) {
        updateObservers.values.forEach { $0.yield(update) }
    }

    func setConnectionState(_ state: FeedConnectionState) {
        connectionState = state
        connectionObservers.values.forEach { $0.yield(state) }
    }
}

// MARK:  -  Observers  -  -

private extension EchoPriceFeedService {
    func addUpdateObserver(
        _ continuation: AsyncStream<PriceUpdate>.Continuation,
        id: UUID
    ) async {
        updateObservers[id] = continuation

        continuation.onTermination = { _ in
            Task {
                await self.removeUpdateObserver(id: id)
            }
        }
    }

    func removeUpdateObserver(id: UUID) {
        updateObservers[id] = nil
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

// MARK:  -  Double+Rounding  -  -

private extension Decimal {
    func roundedToTwoDecimals() -> Decimal {
        (self * 100).rounded(scale: 2) / 100
    }
}
