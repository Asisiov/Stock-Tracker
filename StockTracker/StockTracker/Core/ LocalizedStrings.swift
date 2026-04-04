//
//   LocalizedStrings.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation

enum LocalizedStrings {
    enum HelloWorld {
        static let helloWorld = LocalizedStringResource("hello_world", defaultValue: "Hello, world!")
    }
    
    enum Markets {
        static let title = LocalizedStringResource("markets.title", defaultValue: "Markets")
        static let loadingSymbols = LocalizedStringResource("markets.loading_symbols", defaultValue: "Loading symbols...")
        static let noSymbolsAvailable = LocalizedStringResource("markets.no_symbols_available", defaultValue: "No symbols available")
        static let tryAgaine = LocalizedStringResource("markets.try_again", defaultValue: "Try again")
        static let failedToLoad = LocalizedStringResource("markets.failed_to_load", defaultValue: "Failed to load symbols")
    }
    
    enum SortOption {
        static let price = LocalizedStringResource("sort.price", defaultValue: "Price")
        static let change = LocalizedStringResource("sort.change", defaultValue: "% Change")
        static let sortBy = LocalizedStringResource("sort.sort_by", defaultValue: "Sort by:")
    }
    
    enum Details {
        static let about = LocalizedStringResource("details.about", defaultValue: "About")
    }
    
    enum Feed {
        static var title = LocalizedStringResource("feed.title", defaultValue: "Live Price Feed")
        static var feedRunning = LocalizedStringResource("feed.running", defaultValue: "Feed is running.")
        static var feedNotRunning = LocalizedStringResource("feed.not_running", defaultValue: "Start the feed to see live prices.")
        static var startFeed = LocalizedStringResource("feed.start", defaultValue: "Start Feed")
        static var stopFeed = LocalizedStringResource("feed.stop", defaultValue: "Stop Feed")
    }
    
    enum ConnectionStatus {
        static var connected = LocalizedStringResource("connection.connected", defaultValue: "Connected")
        static var disconnected = LocalizedStringResource("connection.disconnected", defaultValue: "Disconnected")
    }
}
