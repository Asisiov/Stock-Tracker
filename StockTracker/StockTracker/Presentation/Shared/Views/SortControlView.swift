//
//  SortControlView.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

struct SortControlView: View {
    @Binding var selected: SymbolSortOption
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Text(LocalizedStrings.SortOption.sortBy)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: AppSpacing.xxs) {
                ForEach(SymbolSortOption.allCases, id: \.self) { option in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            selected = option
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: option.iconName)
                                .font(.subheadline.weight(.semibold))
                            
                            Text(option.title)
                                .font(.headline)
                        }
                        .foregroundStyle(selected == option ? .primary : .secondary)
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                        .frame(minHeight: 44)
                        .background {
                            if selected == option {
                                RoundedRectangle(cornerRadius: AppRadius.lg,
                                                 style: .continuous)
                                    .fill(Color.white.opacity(0.08))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("sort_\(option.rawValue)")
                    .accessibilityLabel(option.title)
                    .accessibilityAddTraits(selected == option ? [.isSelected] : [])
                }
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
        }
    }
}

#if DEBUG

private struct SortControlContainerView: View {
    @State private var selected: SymbolSortOption = .price
    
    var body: some View {
        SortControlView(selected: $selected)
    }
}

#Preview("Light color scheme") {
    SortControlContainerView()
        .preferredColorScheme(.light)
}

#Preview("Dark color scheme") {
    SortControlContainerView()
        .preferredColorScheme(.dark)
}

#endif
