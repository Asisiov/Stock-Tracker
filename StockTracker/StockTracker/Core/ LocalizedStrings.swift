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
    }
    
    enum SortOption {
        static let price = LocalizedStringResource("sort.price", defaultValue: "Price")
        static let change = LocalizedStringResource("sort.change", defaultValue: "% Change")
        static let sortBy = LocalizedStringResource("sort.sort_by", defaultValue: "Sort by:")
    }
}
