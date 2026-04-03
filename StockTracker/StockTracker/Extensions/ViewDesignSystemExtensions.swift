//
//  ViewDesignSystemExtensions.swift
//  StocksPriceTracker
//
//  Created by Oleksandr on 02.04.2026.
//

import SwiftUI

extension View {
    func appShadow(_ shadow: AppShadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}
