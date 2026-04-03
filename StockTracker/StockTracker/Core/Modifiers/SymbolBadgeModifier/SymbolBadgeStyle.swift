//
//  SymbolBadgeStyle.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

struct SymbolBadgeStyle {
    
    enum Tone {
        case positive
        case negative
        case neutral
    }
    
    enum Size {
        case regular
        case compact
    }
    
    let tone: Tone
    let size: Size
    
    var foregroundColor: Color {
        switch tone {
        case .positive:
            return .positive
        case .negative:
            return .negative
        case .neutral:
            return .neutral
        }
    }
    
    var backgroundColor: Color {
        switch tone {
        case .positive:
            return .darkGreen
        case .negative:
            return .darkNegative
        case .neutral:
            return .neutral
        }
    }
    
    var font: Font {
        switch size {
        case .regular:
            return AppTypography.title
        case .compact:
            return AppTypography.caption
        }
    }
    
    var horizontalPadding: CGFloat {
        AppSpacing.md
    }
    
    var verticalPadding: CGFloat {
        switch size {
        case .regular:
            return AppSpacing.sm
        case .compact:
            return AppSpacing.xs
        }
    }
    
    static func badge(_ tone: Tone) -> SymbolBadgeStyle {
        SymbolBadgeStyle(
            tone: tone,
            size: .regular
        )
    }
    
    static func priceChange(_ tone: Tone) -> SymbolBadgeStyle {
        SymbolBadgeStyle(
            tone: tone,
            size: .compact
        )
    }
}
