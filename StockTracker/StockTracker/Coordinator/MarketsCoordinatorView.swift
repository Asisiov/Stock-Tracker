//
//  MarketsCoordinatorView.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import SwiftUI

struct MarketsCoordinatorView: View {
    @State private var coordinator: MarketsCoordinator

    init(coordinator: MarketsCoordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MarketsFeatureAssembly.makeSymbolsListView(
                viewModel: coordinator.listViewModel,
                onSelectSymbol: { symbolID in
                    coordinator.showDetails(for: symbolID)
                }
            )
            .navigationDestination(for: MarketsRoute.self) { route in
                coordinator.destination(for: route)
            }
        }
    }
}
