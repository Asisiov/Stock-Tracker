//
//  SymbolsCellView.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

struct SymbolsCellView: View {
    
    let item: SymbolRowItem
    
    var body: some View {
        HStack {            
            leftView
            Spacer()
            rightView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var leftView: some View {
        VStack(alignment: .leading) {
            SymbolBadgeView(text: item.title, style: .badge(item.tone))
            Text(item.subtitle)
                .font(AppTypography.body)
                .foregroundStyle(Color.textSecondary)
        }
    }
    
    var rightView: some View {
        VStack(alignment: .trailing) {
            Text(item.price)
                .font(AppTypography.title)
                .foregroundStyle(Color.primary)
            SymbolBadgeView(text: item.priceDelta, style: .priceChange(item.tone))
        }
    }
}

#Preview("Light Positive") {
    SymbolsCellView(item: .previewPositive)
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Light Negative") {
    SymbolsCellView(item: .previewNegative)
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark Positive") {
    SymbolsCellView(item: .previewPositive)
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Dark Negative") {
    SymbolsCellView(item: .previewNegative)
    .padding()
    .preferredColorScheme(.dark)
}
