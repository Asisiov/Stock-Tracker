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

#Preview("Badge Positive") {
    SymbolBadgeView(text: "Apple", style: .badge(.positive))
}

#Preview("Badge Negative") {
    SymbolBadgeView(text: "Apple", style: .badge(.negative))
}

#Preview("Price Change Positive") {
    SymbolBadgeView(text: "+2.65", style: .priceChange(.positive))
}

#Preview("Price Change Negative") {
    SymbolBadgeView(text: "+2.65", style: .priceChange(.negative))
}
