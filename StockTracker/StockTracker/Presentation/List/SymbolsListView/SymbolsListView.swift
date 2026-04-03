//
//  SymbolsListView.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

struct SymbolsListView: View {
    
    @State private var viewModel: SymbolsListViewModel = .build()
    @State private var status: ConnectionStatus = .disconnected
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // TODO: Localisation
                    Text("Custom Text")
                        .font(AppTypography.largeTitle)
                    Spacer()
                    ConnectionIndicatorView(status: $status, size: 10)
                }
                .padding()
                
                ScrollView {
                    VStack {
                        SortControlView(
                            selected: Binding(
                                get: { viewModel.sortOption },
                                set: { viewModel.setSortOption($0) }
                            )
                        )
//                        SortControlView(selected: $sortOption)
                        LazyVStack(spacing: AppSpacing.sm) {
                            ForEach(viewModel.cellViewModels) { item in
                                RoundedRectangle(cornerRadius: 1)
                                    .foregroundColor( Color.backgroundSecondary)
                                    .frame(height: 2)
                                SymbolsCellView(viewModel: item)
                            }
                        }
                    }
                    .padding()
                }
            }
            .task {
                await viewModel.loadStocks()
            }
        }
    }
}

#Preview("Light color scheme") {
    SymbolsListView()
        .preferredColorScheme(.light)
}

#Preview("Dark color scheme") {
    SymbolsListView()
        .preferredColorScheme(.dark)
}
