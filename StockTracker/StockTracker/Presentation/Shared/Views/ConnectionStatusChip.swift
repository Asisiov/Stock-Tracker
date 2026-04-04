//
//  ConnectionStatusChip.swift
//  StockTracker
//
//  Created by Oleksandr on 05.04.2026.
//

import SwiftUI

struct ConnectionStatusChip: View {
    let status: ConnectionStatus
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Circle()
                .fill(status.color)
                .frame(width: 10, height: 10)
            
            Text(status.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(status.foregroundColor)
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(status.backgroundColor)
        .clipShape(Capsule())
    }
}
