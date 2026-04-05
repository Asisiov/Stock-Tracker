//
//  TestSupport.swift
//  StockTracker
//
//  Created by Oleksandr on 05.04.2026.
//

import Foundation
import Testing
@testable import StockTracker

// MARK:  -  Fixtures  -  -

enum Fixtures {
    static func symbol(
        id: String = "AAPL",
        ticker: String? = nil,
        name: String = "Apple Inc.",
        details: String = "Sample description",
        currentPrice: Decimal = 100,
        previousPrice: Decimal = 99
    ) -> StockSymbol {
        StockSymbol(
            ticker: ticker ?? id,
            name: name,
            details: details,
            previousPrice: previousPrice,
            currentPrice: currentPrice,
            currencyCode: "USD"
        )
    }

    static func update(
        symbolID: String = "AAPL",
        previousPrice: Decimal = 100,
        currentPrice: Decimal = 101,
        sequence: Int = 1,
        emittedAt: Date = .distantPast
    ) -> PriceUpdate {
        PriceUpdate(
            symbolID: symbolID,
            previousPrice: previousPrice,
            currentPrice: currentPrice,
            sequence: sequence,
            emittedAt: emittedAt
        )
    }

    static func payloadJSON(
        symbolID: String = "AAPL",
        previousPrice: Decimal = 100,
        currentPrice: Decimal = 101,
        sequence: Int = 1,
        emittedAt: String = "2026-04-05T10:00:00Z"
    ) -> String {
        """
        {
          "symbolID": "\(symbolID)",
          "previousPrice": \(previousPrice),
          "currentPrice": \(currentPrice),
          "sequence": \(sequence),
          "emittedAt": "\(emittedAt)"
        }
        """
    }
}

// MARK:  -  AsyncStream Helpers  -  -

enum AsyncStreamTestHelper {
    static func next<T>(
        from stream: AsyncStream<T>
    ) async -> T? {
        var iterator = stream.makeAsyncIterator()
        return await iterator.next()
    }
}
