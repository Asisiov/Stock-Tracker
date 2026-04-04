//
//  PriceChangeChip.swift
//  StockTracker
//
//  Created by Oleksandr on 05.04.2026.
//

import SwiftUI

struct PriceChangeChip: View {
    let text: String
    let tone: SymbolBadgeStyle.Tone
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: tone.iconName)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(tone.accentColor)
            
            Text(text)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(tone.accentColor)
        }
    }
}
