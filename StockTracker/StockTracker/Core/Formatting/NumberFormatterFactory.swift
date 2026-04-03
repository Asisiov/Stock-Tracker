//
//  NumberFormatterFactory.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation

protocol NumberFormatterFactoryProtocol {
    func makeDecimalFormatter(
        locale: Locale,
        minimumFractionDigits: Int,
        maximumFractionDigits: Int,
        usesGroupingSeparator: Bool
    ) -> NumberFormatter
}

final class NumberFormatterFactory: NumberFormatterFactoryProtocol {
    func makeDecimalFormatter(
        locale: Locale,
        minimumFractionDigits: Int,
        maximumFractionDigits: Int,
        usesGroupingSeparator: Bool = true
    ) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.usesGroupingSeparator = usesGroupingSeparator
        formatter.generatesDecimalNumbers = true
        return formatter
    }
}
