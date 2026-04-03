//
//  SymbolsJSONLoaderTests.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation
import Testing
@testable import StockTracker

@Suite("SymbolsJSONLoader tests")
struct SymbolsJSONLoaderTests {

    @Test("Loads symbols from JSON fixture")
    func loadsSymbolsFromJSONFixture() async throws {
        let sut = SymbolsJSONLoader(
            bundle: testBundle,
            fileName: "mock_symbols_fixture"
        )

        let symbols = try await sut.loadSymbols()
        
        let expectedPreviousPrice = try #require(Decimal(string: "189.32"))
        let expectedCurrentPrice = try #require(Decimal(string: "190.11"))

        #expect(symbols.count == 2)

        #expect(symbols[0].ticker == "AAPL")
        #expect(symbols[0].name == "Apple Inc.")
        #expect(symbols[0].details == "Consumer technology company known for iPhone, Mac, iPad, services and wearables.")
        #expect(symbols[0].previousPrice == expectedPreviousPrice)
        #expect(symbols[0].currentPrice == expectedCurrentPrice)
        
        #expect(symbols[1].ticker == "MSFT")
        #expect(symbols[1].name == "Microsoft Corporation")
    }

    @Test("Throws fileNotFound when resource does not exist")
    func throwsFileNotFoundWhenFileIsMissing() async throws {
        let sut = SymbolsJSONLoader(
            bundle: testBundle,
            fileName: "missing_file"
        )

        await #expect(throws: SymbolsJSONLoaderError.fileNotFound) {
            try await sut.loadSymbols()
        }
    }

    private var testBundle: Bundle {
        Bundle(for: BundleToken.self)
    }
}

private final class BundleToken {}
