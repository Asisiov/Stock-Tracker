//
//  URLSessionWebSocketClient.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  URLSessionWebSocketClient  -  -

actor URLSessionWebSocketClient: WebSocketClient {
    private let url: URL
    private let session: URLSession
    private var task: URLSessionWebSocketTask?

    init(
        url: URL,
        session: URLSession = .shared
    ) {
        self.url = url
        self.session = session
    }

    func connect() async throws {
        guard task == nil else { return }

        print("--- connect to \(url)")
        let task = session.webSocketTask(with: url)
        self.task = task
        task.resume()
    }

    func send(text: String) async throws {
        guard let task else {
            throw WebSocketClientError.notConnected
        }

        print("--- send message: \(text)")
        try await task.send(.string(text))
    }

    func receive() async throws -> String {
        guard let task else {
            throw WebSocketClientError.notConnected
        }

        let message = try await task.receive()

        switch message {
        case .string(let text):
            print("--- receive message: \(text)")
            return text

        case .data(let data):
            guard let text = String(data: data, encoding: .utf8) else {
                throw WebSocketClientError.invalidTextPayload
            }
            
            print("--- receive package: \(text)")
            return text

        @unknown default:
            throw WebSocketClientError.unsupportedMessage
        }
    }

    func disconnect() async {
        print("--- disconnect from \(url)")
        task?.cancel(with: .normalClosure, reason: nil)
        task = nil
    }
}
