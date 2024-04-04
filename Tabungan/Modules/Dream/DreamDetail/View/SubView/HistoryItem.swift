//
//  HistoryList.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 04/04/24.
//

import SwiftUI

struct HistoryItem: View {
    @StateObject var DreamDetailViewModel = DreamDetailVM()
    let billHistory: BillHistory
    
    var body: some View {
        NavigationStack {
            HStack {
                Image(systemName: billHistory.type == 0 ? "arrow.up" : "arrow.down")
                    .font(.headline)
                    .padding()
                    .background(.purple.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(billHistory.userName)
                        .font(.headline)
                    Text("bill history note")
                        .font(.callout)
                    Text(DreamDetailViewModel.formatDate(from: billHistory.created))
                        .font(.callout)
                }
                
                Spacer()
                Text("\(billHistory.type == 0 ? "+" : "-")Rp\(String(format: "%.0f", billHistory.current))")
                    .foregroundStyle(billHistory.type == 0 ? .green : .red)
                    .font(.subheadline) 
            }
        }
    }
}

#Preview {
    HistoryItem(billHistory: BillHistory(id: "123", userId: "123", dreamId: "123", userName: "user", type: 1, amount: 200, current: 200, created: 12344, updated: 1233))
}
