//
//  SymbolsCellViewModel.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

@MainActor
@Observable
final class SymbolCellViewModel: Identifiable, Equatable {
    var id: String { title }
    var title: String
    var subtitle: String
    var price: String
    var priceDelta: String
    var tone: SymbolBadgeStyle.Tone
    
    init(title: String,
         subtitle: String,
         price: String,
         priceDelta: String,
         tone: SymbolBadgeStyle.Tone) {
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.priceDelta = priceDelta
        self.tone = tone
    }
    
    static func == (lhs: SymbolCellViewModel, rhs: SymbolCellViewModel) -> Bool {
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.price == rhs.price &&
        lhs.priceDelta == rhs.priceDelta &&
        lhs.tone == rhs.tone
    }
}

extension SymbolCellViewModel {
    static var previewPositive: Self {
        Self(title: "AAPL",
             subtitle: "Apple Inc.",
             price: "140.00",
             priceDelta: "+0.01",
             tone: .positive)
    }
    
    static var previewNegative: Self {
        Self(title: "AAPL",
             subtitle: "Apple Inc.",
             price: "140.00",
             priceDelta: "-0.01",
             tone: .negative)
    }
}
