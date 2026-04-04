//
//  SymbolBadgeView.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

struct SymbolBadgeView: View {
    let text: String
    let style: SymbolBadgeStyle
    
    init(text: String, style: SymbolBadgeStyle) {
        self.text = text
        self.style = style
    }
    
    var body: some View {
        Text(text)
            .symbolBadgeStyle(style)
    }
}

#Preview("Light Color Scheme - Badge") {
    VStack(spacing: AppSpacing.sm) {
        SymbolBadgeView(text: "Apple", style: .badge(.positive))
            .preferredColorScheme(.light)
        SymbolBadgeView(text: "Apple", style: .badge(.neutral))
            .preferredColorScheme(.light)
        SymbolBadgeView(text: "Apple", style: .badge(.negative))
            .preferredColorScheme(.light)
    }
}

#Preview("Dark Color Scheme - Badge") {
    VStack(spacing: AppSpacing.sm) {
        SymbolBadgeView(text: "Apple", style: .badge(.positive))
            .preferredColorScheme(.dark)
        SymbolBadgeView(text: "Apple", style: .badge(.neutral))
            .preferredColorScheme(.dark)
        SymbolBadgeView(text: "Apple", style: .badge(.negative))
            .preferredColorScheme(.dark)
    }
    .preferredColorScheme(.dark)
}

#Preview("Light Color Scheme - Price Change") {
    VStack(spacing: AppSpacing.sm) {
        SymbolBadgeView(text: "+2.65", style: .priceChange(.positive))
            .preferredColorScheme(.light)
        SymbolBadgeView(text: "+0.00", style: .priceChange(.neutral))
            .preferredColorScheme(.light)
        SymbolBadgeView(text: "+2.65", style: .priceChange(.negative))
            .preferredColorScheme(.light)
    }
}

#Preview("Dark Color Scheme - Price Change") {
    VStack(spacing: AppSpacing.sm) {
        SymbolBadgeView(text: "+2.65", style: .priceChange(.positive))
            .preferredColorScheme(.dark)
        SymbolBadgeView(text: "+0.00", style: .priceChange(.neutral))
            .preferredColorScheme(.dark)
        SymbolBadgeView(text: "+2.65", style: .priceChange(.negative))
            .preferredColorScheme(.dark)
    }
}
