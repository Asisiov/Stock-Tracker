//
//  SymbolBadgeModifier.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

private struct SymbolBadgeModifier: ViewModifier {
    let style: SymbolBadgeStyle
    
    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundStyle(style.foregroundColor)
            .padding(.horizontal, style.horizontalPadding)
            .padding(.vertical, style.verticalPadding)
            .background(style.backgroundColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppRadius.md,
                    style: .continuous
                )
            )
            .lineLimit(1)
            .minimumScaleFactor(0.85)
    }
}

extension View {
    func symbolBadgeStyle(_ style: SymbolBadgeStyle) -> some View {
        modifier(SymbolBadgeModifier(style: style))
    }
}
