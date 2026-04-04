//
//  MarketsCoordinator.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import SwiftUI

@MainActor
@Observable
final class MarketsCoordinator {
    var path: [MarketsRoute] = []

    func showDetails(for symbolID: String) {
        path.append(.symbolDetails(symbolID))
    }

    @ViewBuilder
    func destination(for route: MarketsRoute) -> some View {
        switch route {
        case .symbolDetails(let symbolID):
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
                    connectionStatus: .disconnected
                ), onBack: { [weak self] in
                    self?.path.removeLast()
                })
        }
    }
}
