//
//  StockTrackerApp.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import SwiftUI

@main
struct StockTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MarketsFeatureAssembly.makeCoordinatorView()
        }
    }
}
