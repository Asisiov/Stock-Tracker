//
//  SymbolPresentationMapping.swift
//  StockTracker
//
//  Created by Oleksandr on 06.04.2026.
//

import Foundation

// MARK:  -  SymbolPresentationMapping  -  -

protocol SymbolPresentationMapping {
    func makeSnapshot(from symbol: StockSymbol) -> SymbolPresentationSnapshot
}
