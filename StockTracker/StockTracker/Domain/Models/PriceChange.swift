//
//  PriceChange.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation

struct PriceChange: Hashable, Codable {
    
    // swiftlint: disable identifier_name
    enum Direction: String, Codable {
        case up
        case down
        case unchanged
        
        init?(value: Decimal) {
            if value > 0 {
                self = .up
            } else if value < 0 {
                self = .down
            } else {
                self = .unchanged
            }
        }
    }
    // swiftlint: enable identifier_name

    let amount: Decimal
    let percentage: Decimal
    let direction: Direction

    init(previous: Decimal, current: Decimal) {
        let delta = current - previous
        let percent: Decimal

        if previous == 0 {
            percent = 0
        } else {
            percent = (delta / previous) * 100
        }

        self.amount = delta
        self.percentage = percent
        self.direction = Direction(value: delta) ?? .unchanged
    }
}
