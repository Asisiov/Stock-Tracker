//
//  StockTrackerApp.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import SwiftUI

@main
struct StockTrackerApp: App {
    
    @State private var coordinator = MarketsCoordinator()
    var body: some Scene {
        WindowGroup {
            MarketsCoordinatorView(coordinator: coordinator)
        }
    }
}
