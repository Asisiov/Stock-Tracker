//
//  AppTypography.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import SwiftUI

enum AppTypography {
    static let largeTitle = Font.system(.largeTitle, design: .default).weight(.bold)
    static let title = Font.system(.title3, design: .default).weight(.semibold)
    static let headline = Font.system(.headline, design: .default).weight(.semibold)
    static let body = Font.system(.body, design: .default)
    static let bodySecondary = Font.system(.subheadline, design: .default)
    static let caption = Font.system(.caption, design: .default)
    static let captionStrong = Font.system(.caption, design: .default).weight(.semibold)
    static let price = Font.system(size: 24, weight: .bold, design: .rounded)
}
