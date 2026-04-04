//
//  SymbolDetailsView.swift
//  StockTracker
//
//  Created by Oleksandr on 04.04.2026.
//

import SwiftUI

struct SymbolDetailsView: View {
    var body: some View {
        Text("SymbolDetailsView")
    }
}

#Preview("Light color scheme") {
    SymbolDetailsView()
        .preferredColorScheme(.light)
}


#Preview("Dark color scheme") {
    SymbolDetailsView()
        .preferredColorScheme(.dark)
}
