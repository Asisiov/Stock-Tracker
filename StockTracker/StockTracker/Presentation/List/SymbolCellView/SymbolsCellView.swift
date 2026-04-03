//
//  SymbolsCellView.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

struct SymbolsCellView: View {
    
    @State var viewModel: SymbolCellViewModel
    
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
            SymbolBadgeView(text: viewModel.title, style: .badge(viewModel.tone))
            Text(viewModel.subtitle)
                .font(AppTypography.body)
                .foregroundStyle(Color.textSecondary)
        }
    }
    
    var rightView: some View {
        VStack(alignment: .trailing) {
            Text(viewModel.price)
                .font(AppTypography.title)
                .foregroundStyle(Color.primary)
            SymbolBadgeView(text: viewModel.priceDelta, style: .priceChange(viewModel.tone))
        }
    }
}

#Preview("Light Positive") {
    SymbolsCellView(viewModel: .previewPositive)
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Light Negative") {
    SymbolsCellView(viewModel: .previewNegative)
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark Positive") {
    SymbolsCellView(viewModel: .previewPositive)
    .padding()
    .preferredColorScheme(.dark)
}

#Preview("Dark Negative") {
    SymbolsCellView(viewModel: .previewNegative)
    .padding()
    .preferredColorScheme(.dark)
}
