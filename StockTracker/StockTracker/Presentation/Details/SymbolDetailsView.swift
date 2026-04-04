//
//  SymbolDetailsView.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import SwiftUI

struct SymbolDetailsView: View {
    
    @Bindable var viewModel: SymbolDetailsViewModel
    let onBack: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                mainSection
                sectionSeparator
                aboutSection
                sectionSeparator
                liveFeedSection
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xxl)
        }
        .navigationTitle(LocalizedStrings.Markets.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ConnectionStatusChip(status: viewModel.connectionStatus)
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: AppSpacing.sm) {
            Button(action: onBack) {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "chevron.left")
                    Text(LocalizedStrings.Markets.title)
                }
                .font(AppTypography.headline)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            ConnectionStatusChip(status: viewModel.connectionStatus)
        }
    }
    
    private var mainSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SymbolBadgeView(text: viewModel.ticker, style: .badge(viewModel.tone))
            
            Text(viewModel.companyName)
                .font(AppTypography.title)
                .foregroundStyle(Color.textSecondary)
            
            Text(viewModel.priceText)
                .font(AppTypography.largeTitle)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            PriceChangeChip(
                text: viewModel.changeText,
                tone: viewModel.tone
            )
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(LocalizedStrings.Details.about)
                .font(AppTypography.title)
                .foregroundStyle(Color.textPrimary)
            
            Text(viewModel.aboutText)
                .font(AppTypography.headline)
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var liveFeedSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(viewModel.feedTitle)
                .font(AppTypography.title)
                .foregroundStyle(Color.textPrimary)
            
            Text(viewModel.feedDescriptionText)
                .font(AppTypography.headline)
                .foregroundStyle(Color.textSecondary)
            
            Button(action: viewModel.onFeedButtonTap) {
                HStack(spacing: AppSpacing.sm) {
                    if viewModel.isPerformingFeedAction {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: viewModel.feedButtonIconName)
                    }
                    
                    Text(viewModel.feedButtonTitle)
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
    
    private var sectionSeparator: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(height: 1)
    }
}

#Preview("Light Color Scheme") {
    SymbolDetailsView(
        viewModel: SymbolDetailsViewModel(
            symbolID: "brk-b",
            ticker: "BRK.B",
            companyName: "Berkshire Hathaway",
            priceText: "$432.19",
            changeText: "+0.84",
            tone: .positive,
            aboutText: "Berkshire Hathaway Inc. engages in the insurance, freight rail transportation, and utility businesses worldwide.",
            isFeedRunning: false,
            connectionStatus: .disconnected,
        ),
        onBack: { }
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Color Scheme") {
    SymbolDetailsView(
        viewModel: SymbolDetailsViewModel(
            symbolID: "brk-b",
            ticker: "BRK.B",
            companyName: "Berkshire Hathaway",
            priceText: "$432.19",
            changeText: "+0.84",
            tone: .positive,
            aboutText: "Berkshire Hathaway Inc. engages in the insurance, freight rail transportation, and utility businesses worldwide.",
            isFeedRunning: false,
            connectionStatus: .disconnected,
        ),
        onBack: { }
    )
    .preferredColorScheme(.dark)
}

private struct PriceChangeChip: View {
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

private struct ConnectionStatusChip: View {
    let status: ConnectionStatus
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)
            
            Text(status.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(status.foregroundColor)
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(status.backgroundColor)
        .clipShape(Capsule())
    }
}
