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
                Image(systemName: billHistory.type == 0 ? "arrow.down" : "arrow.up")
                    .font(.headline)
                    .padding(10)
                    .background(.purple.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(billHistory.userName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    ForEach(billHistory.notes ?? [], id: \.id) { note in
                        Text(note.note)
                            .font(.footnote)
                    }
                    
                    Text(DreamDetailViewModel.formatDate(from: billHistory.created))
                        .font(.caption)
                }
                
                Spacer()
                Text("\(billHistory.type == 0 ? "+" : "-") \(DreamDetailViewModel.formatCurrency(billHistory.current))")
                    .foregroundStyle(billHistory.type == 0 ? .green : .red)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    HistoryItem(billHistory: BillHistory(id: "123", userId: "123", dreamId: "123", userName: "user", type: 1, amount: 200000, current: 200000, created: 12344, updated: 1233))
}
