//
//  SymbolsLoading.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import Foundation

protocol SymbolsLoading {
    func loadSymbols() throws -> [StockSymbol]
}

enum SymbolsJSONLoaderError: Error {
    case fileNotFound
}

final class SymbolsJSONLoader: SymbolsLoading {
    private let bundle: Bundle
    private let fileName: String

    init(bundle: Bundle = .main, fileName: String = "mock_symbols") {
        self.bundle = bundle
        self.fileName = fileName
    }

    func loadSymbols() throws -> [StockSymbol] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw SymbolsJSONLoaderError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let dtos = try decoder.decode([StockSymbolDTO].self, from: data)

        return dtos.map { $0.toDomain() }
    }
}
