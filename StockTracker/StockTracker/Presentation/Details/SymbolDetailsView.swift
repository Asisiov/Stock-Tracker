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
    
    private var sectionSeparator: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(height: 1)
    }
}

//#Preview("Light Color Scheme") {
//    SymbolDetailsView(
//        viewModel: SymbolDetailsViewModel(
//            symbolID: "brk-b",
//            ticker: "BRK.B",
//            companyName: "Berkshire Hathaway",
//            priceText: "$432.19",
//            changeText: "+0.84",
//            tone: .positive,
//            aboutText: "Berkshire Hathaway Inc. engages in the insurance, freight rail transportation, and utility businesses worldwide.",
//            connectionStatus: .disconnected,
//        ),
//        onBack: { }
//    )
//    .preferredColorScheme(.light)
//}
//
//#Preview("Dark Color Scheme") {
//    SymbolDetailsView(
//        viewModel: SymbolDetailsViewModel(
//            symbolID: "brk-b",
//            ticker: "BRK.B",
//            companyName: "Berkshire Hathaway",
//            priceText: "$432.19",
//            changeText: "+0.84",
//            tone: .positive,
//            aboutText: "Berkshire Hathaway Inc. engages in the insurance, freight rail transportation, and utility businesses worldwide.",
//            connectionStatus: .disconnected,
//        ),
//        onBack: { }
//    )
//    .preferredColorScheme(.dark)
//}
