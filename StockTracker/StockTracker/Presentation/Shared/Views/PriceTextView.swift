//
//  PriceTextView.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

struct PriceTextView: View, Equatable {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(AppTypography.title)
            .foregroundStyle(Color.textPrimary)
            .contentTransition(.numericText())
    }
}

#Preview {
    PriceTextView(text: "$546.66")
}
