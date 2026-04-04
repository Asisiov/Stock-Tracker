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
    let onSelectSymbol: (String) -> Void
    
    var body: some View {
        VStack {
            headerView
                .padding(.horizontal)
            
            SortControlView(selected: $viewModel.sortOption)
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            guard case .idle = viewModel.state else { return }
            await viewModel.loadStocks()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(LocalizedStrings.Markets.title)
                .font(AppTypography.largeTitle)
            Spacer()
            ConnectionIndicatorView(status: $status, size: 10)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
            
        case .empty:
            emptyView
            
        case .failed:
            failedView
            
        case .content(let items):
            listView(items: items)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
            Text(LocalizedStrings.Markets.loadingSymbols)
                .font(AppTypography.body)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private var emptyView: some View {
        ContentUnavailableView {
            Label(LocalizedStrings.Markets.noSymbolsAvailable,
                  systemImage: "person.badge.plus")
        } actions: {
            Button(LocalizedStrings.Markets.tryAgaine) {
                Task {
                    await viewModel.loadStocks()
                }
            }
        }
    }
    
    private var failedView: some View {
        VStack(spacing: AppSpacing.md) {
            Text(LocalizedStrings.Markets.failedToLoad)
                .font(AppTypography.title)
                .foregroundStyle(Color.primary)
            
            Button(LocalizedStrings.Markets.tryAgaine) {
                Task {
                    await viewModel.loadStocks()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func listView(items: [SymbolCellViewModel]) -> some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(items) { item in
                    RoundedRectangle(cornerRadius: 1)
                        .foregroundStyle(Color.backgroundSecondary)
                        .frame(height: 2)
                    
                    Button {
                        onSelectSymbol(item.id)
                    } label: {
                        SymbolsCellView(viewModel: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

#Preview("Light color scheme") {
    SymbolsListView(onSelectSymbol: { _ in })
        .preferredColorScheme(.light)
}

#Preview("Dark color scheme") {
    SymbolsListView(onSelectSymbol: { _ in })
        .preferredColorScheme(.dark)
}
