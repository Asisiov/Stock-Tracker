//
//  FormattersTests.swift
//  StocksPriceTrackerTests
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation
import Testing
@testable import StockTracker

@Suite("Formatters Tests")
struct FormattersTests {

    // MARK: - Price Formatter -

    @Test(
        "PriceFormatter formats price for supported locales",
        arguments: [
            ("en_US", "1234.56", "$1,234.56"),
            ("uk_UA", "1234.56", "1 234,56 USD")
        ]
    )
    func priceFormatter_formatsPrice(
        localeIdentifier: String,
        input: String,
        expected: String
    ) throws {
        let sut = PriceFormatter(locale: Locale(identifier: localeIdentifier))

        let value = try #require(Decimal(string: input))
        let result = sut.string(from: value, currencyCode: "USD")

        #expect(normalizeSpaces(result) == expected)
    }

    // MARK: - Price Change Formatter -

    @Test("PriceChangeFormatter adds plus sign for positive values")
    func priceChangeFormatter_positiveValue_addsPlusSign() throws {
        let sut = PriceChangeFormatter(locale: Locale(identifier: "en_US"))

        let value = try #require(Decimal(string: "12.3"))
        let result = sut.string(from: value, currencyCode: "USD")

        #expect(result == "+$12.30")
    }

    @Test("PriceChangeFormatter keeps minus sign for negative values")
    func priceChangeFormatter_negativeValue_keepsMinusSign() throws {
        let sut = PriceChangeFormatter(locale: Locale(identifier: "en_US"))

        let value = try #require(Decimal(string: "-12.3"))
        let result = sut.string(from: value, currencyCode: "USD")

        #expect(result == "-$12.30")
    }

    @Test("PriceChangeFormatter formats zero without plus sign")
    func priceChangeFormatter_zeroValue_formatsWithoutPlusSign() {
        let sut = PriceChangeFormatter(locale: Locale(identifier: "en_US"))

        let result = sut.string(from: 0, currencyCode: "USD")

        #expect(result == "$0.00")
    }

    @Test("PriceChangeFormatter normalizes negative zero to zero")
    func priceChangeFormatter_negativeZero_isNormalizedToZero() throws {
        let sut = PriceChangeFormatter(locale: Locale(identifier: "en_US"))

        let value = try #require(Decimal(string: "-0.004"))
        let result = sut.string(from: value, currencyCode: "USD")

        #expect(result == "$0.00")
    }

    // MARK: - Generic Number Formatter -

    @Test("GenericNumberFormatter respects fraction digits")
    func genericNumberFormatter_respectsFractionDigits() throws {
        let sut = GenericNumberFormatter(locale: Locale(identifier: "en_US"))

        let value = try #require(Decimal(string: "1234.5678"))
        let result = sut.string(
            from: value,
            minimumFractionDigits: 1,
            maximumFractionDigits: 3,
            usesGroupingSeparator: true
        )

        #expect(result == "$1,234.568")
    }

    @Test("GenericNumberFormatter can disable grouping separator")
    func genericNumberFormatter_canDisableGroupingSeparator() throws {
        let sut = GenericNumberFormatter(locale: Locale(identifier: "en_US"))

        let value = try #require(Decimal(string: "1234.56"))
        let result = sut.string(
            from: value,
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
            usesGroupingSeparator: false
        )

        #expect(result == "$1234.56")
    }

    // MARK: - Helpers -

    private func normalizeSpaces(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\u{00A0}", with: " ")
            .replacingOccurrences(of: "\u{202F}", with: " ")
    }
}
