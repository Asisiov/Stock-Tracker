//
//  SymbolsListView.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

struct SymbolsListView: View {
    
    @State private var viewModel: SymbolsListViewModel
    @State private var status: ConnectionStatus
    let onSelectSymbol: (String) -> Void
    
    init(viewModel: SymbolsListViewModel,
         status: ConnectionStatus = .disconnected,
         onSelectSymbol: @escaping (String) -> Void) {
        self.viewModel = viewModel
        self.status = status
        self.onSelectSymbol = onSelectSymbol
    }
    
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
            viewModel.onTask()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(LocalizedStrings.Markets.title)
                .font(AppTypography.largeTitle)
            
            Spacer()
            
            ConnectionStatusChip(status: viewModel.connectionStatus)
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
                viewModel.onTask()
            }
        }
    }
    
    private var failedView: some View {
        VStack(spacing: AppSpacing.md) {
            Text(LocalizedStrings.Markets.failedToLoad)
                .font(AppTypography.title)
                .foregroundStyle(Color.primary)
            
            Button(LocalizedStrings.Markets.tryAgaine) {
                viewModel.onTask()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func listView(items: [SymbolRowItem]) -> some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(items) { item in
                    RoundedRectangle(cornerRadius: 1)
                        .foregroundStyle(Color.backgroundSecondary)
                        .frame(height: 2)
                    
                    Button {
                        onSelectSymbol(item.id)
                    } label: {
                        SymbolsCellView(
                            viewModel: SymbolCellViewModel(
                                title: item.title,
                                subtitle: item.subtitle,
                                price: item.price,
                                priceDelta: item.priceDelta,
                                tone: item.tone
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            
            liveFeedSection
                .padding()
        }
    }
    
    private var liveFeedSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(viewModel.connectionStatus.feedTitle)
                .font(AppTypography.title)
                .foregroundStyle(Color.textPrimary)
            
            Text(viewModel.connectionStatus.feedDescriptionText)
                .font(AppTypography.headline)
                .foregroundStyle(Color.textSecondary)
            
            Button(action: viewModel.onFeedButtonTap) {
                HStack(spacing: AppSpacing.sm) {
                    if viewModel.isPerformingFeedAction {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: viewModel.connectionStatus.feedButtonIconName)
                    }
                    
                    Text(viewModel.connectionStatus.feedButtonTitle)
                        .font(AppTypography.title)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(viewModel.connectionStatus.inverseBackgroundColor)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isPerformingFeedAction)
        }
    }
}

// MARK:  -  SymbolsListView+Preview  -  -

private extension SymbolsListViewModel {
    static var previewConnectedViewModel: SymbolsListViewModel {
        SymbolsListPreviewFactory.make(connectionState: .connected)
    }
    
    static var previewDisconnectedViewModel: SymbolsListViewModel {
        SymbolsListPreviewFactory.make(connectionState: .disconnected)
    }
}

#Preview("Light Color Scheme - Disconnected") {
    SymbolsListView(viewModel: .previewDisconnectedViewModel,
                    onSelectSymbol: { _ in })
        .preferredColorScheme(.light)
}

#Preview("Light Color Scheme - Connected") {
    SymbolsListView(viewModel: .previewConnectedViewModel,
                    onSelectSymbol: { _ in })
        .preferredColorScheme(.light)
}

#Preview("Dark Color Scheme - Disconnected") {
    SymbolsListView(viewModel: .previewDisconnectedViewModel,
                    onSelectSymbol: { _ in })
        .preferredColorScheme(.dark)
}

#Preview("Dark Color Scheme - Connected") {
    SymbolsListView(viewModel: .previewConnectedViewModel,
                    onSelectSymbol: { _ in })
        .preferredColorScheme(.dark)
}

