//
//  ConnectionIndicatorView.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 03.04.2026.
//

import SwiftUI

struct ConnectionIndicatorView: View {
    @Binding var status: ConnectionStatus
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(status.color)
            .frame(width: size, height: size)
    }
}
