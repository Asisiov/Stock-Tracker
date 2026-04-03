//
//  Shadows.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import SwiftUI

// swiftlint: disable identifier_name

struct AppShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// swiftlint: enable identifier_name

enum AppShadows {
    static let card = AppShadow(
        color: Color.shadowPrimary.opacity(0.16),
        radius: 10,
        x: 0,
        y: 4
    )
    
    static let floating = AppShadow(
        color: Color.shadowPrimary.opacity(0.20),
        radius: 16,
        x: 0,
        y: 8
    )
}
