//
//  WebSocketClient.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import Foundation

// MARK:  -  WebSocketClient  -  -

protocol WebSocketClient: Actor {
    func connect() async throws
    func send(text: String) async throws
    func receive() async throws -> String
    func disconnect() async
}

// MARK:  -  WebSocketClientError  -  -

enum WebSocketClientError: Error, Equatable {
    case notConnected
    case invalidTextPayload
    case unsupportedMessage
}
