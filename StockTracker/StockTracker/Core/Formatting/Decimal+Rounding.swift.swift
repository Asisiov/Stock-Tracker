//
//  Decimal+Rounding.swift.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation

extension Decimal {
    func rounded(
        scale: Int,
        mode: NSDecimalNumber.RoundingMode = .plain
    ) -> Decimal {
        var value = self
        var result = Decimal()

        NSDecimalRound(&result, &value, scale, mode)
        return result
    }
}
