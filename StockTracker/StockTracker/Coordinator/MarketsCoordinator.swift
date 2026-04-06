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
    var path: [MarketsRoute] = [] {
        didSet {
            syncSelectionWithNavigation()
        }
    }

    let listViewModel: SymbolsListViewModel
    
    init(listViewModel: SymbolsListViewModel) {
        self.listViewModel = listViewModel
    }
    
    func showDetails(for symbolID: String) {
        listViewModel.selectSymbol(id: symbolID)
        path.append(.symbolDetails(symbolID))
    }
    
    func goBack() {
        guard path.isEmpty == false else { return }
        path.removeLast()
    }

    @ViewBuilder
    func destination(for route: MarketsRoute) -> some View {
        switch route {
        case .symbolDetails(let symbolID):
            if let detailsViewModel = listViewModel.detailsViewModel,
               detailsViewModel.symbolID == symbolID {
                SymbolDetailsView(
                    viewModel: detailsViewModel,
                    onBack: { [weak self] in
                        self?.goBack()
                    }
                )
            } else {
                Text("Details state is unavailable.")
            }
        }
    }
}

// MARK:  -  Private  -  -

private extension MarketsCoordinator {
    func syncSelectionWithNavigation() {
        let hasDetailsRoute = path.contains { route in
            switch route {
            case .symbolDetails:
                return true
            }
        }

        guard hasDetailsRoute == false else { return }
        listViewModel.clearSelection()
    }
}
