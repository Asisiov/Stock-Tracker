//
//  Formatters.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation

protocol PriceFormatting {
    func string(from value: Decimal, currencyCode: String) -> String
}

protocol PriceChangeFormatting {
    func string(from value: Decimal, currencyCode: String) -> String
}

protocol NumberFormatting {
    func string(
        from value: Decimal,
        minimumFractionDigits: Int,
        maximumFractionDigits: Int,
        usesGroupingSeparator: Bool
    ) -> String
}

/// Formats the current instrument price into a format ready for display in the UI.
/// 1234.56 → 1,234.56
/// 1234.56 → 1 234,56
final class PriceFormatter: PriceFormatting {
    private let formatter: NumberFormatter

    init(
        locale: Locale,
        factory: NumberFormatterFactoryProtocol = NumberFormatterFactory()
    ) {
        self.formatter = factory.makeDecimalFormatter(
            locale: locale,
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
            usesGroupingSeparator: true
        )
    }

    func string(from value: Decimal, currencyCode: String) -> String {
        formatter.currencyCode = currencyCode
        return formatter.string(from: value as NSDecimalNumber) ?? "—"
    }
}

/// Formats the price change as a separate display value.
/// 12.3 → +12.30
/// -3.2 → -3.20
/// 0 → 0.00
final class PriceChangeFormatter: PriceChangeFormatting {
    private let factory: NumberFormatterFactoryProtocol
    private let scale: Int
    private let locale: Locale
    
    private lazy var signedFormatter: NumberFormatter = {
        let formatter = makeFormatter()
        formatter.positivePrefix = "+"
        return formatter
    }()
    
    private lazy var zeroFormatter: NumberFormatter = {
        makeFormatter()
    }()

    init(
        locale: Locale,
        scale: Int = 2,
        factory: NumberFormatterFactoryProtocol = NumberFormatterFactory()
    ) {
        self.scale = scale
        self.factory = factory
        self.locale = locale
    }

    func string(from value: Decimal, currencyCode: String) -> String {
        let roundedValue = value.rounded(scale: scale)
        let normalizedValue: Decimal = roundedValue == 0 ? 0 : roundedValue

        let formatter = normalizedValue == 0 ? zeroFormatter : signedFormatter
        formatter.currencyCode = currencyCode
        return formatter.string(from: normalizedValue as NSDecimalNumber) ?? "—"
    }
    
    private func makeFormatter() -> NumberFormatter {
        factory.makeDecimalFormatter(
            locale: locale,
            minimumFractionDigits: scale,
            maximumFractionDigits: scale,
            usesGroupingSeparator: true
        )
    }
}

/// Formats any standard numbers that are neither the current price nor the price change.
final class GenericNumberFormatter: NumberFormatting {
    private let locale: Locale
    private let factory: NumberFormatterFactoryProtocol

    init(
        locale: Locale,
        factory: NumberFormatterFactoryProtocol = NumberFormatterFactory()
    ) {
        self.locale = locale
        self.factory = factory
    }

    func string(
        from value: Decimal,
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 2,
        usesGroupingSeparator: Bool = true
    ) -> String {
        let formatter = factory.makeDecimalFormatter(
            locale: locale,
            minimumFractionDigits: minimumFractionDigits,
            maximumFractionDigits: maximumFractionDigits,
            usesGroupingSeparator: usesGroupingSeparator
        )

        return formatter.string(from: value as NSDecimalNumber) ?? "—"
    }
}
