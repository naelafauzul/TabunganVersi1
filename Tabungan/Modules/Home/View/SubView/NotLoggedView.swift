//
//  NotLoggedView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 22/05/24.
//

import SwiftUI

struct NotLoggedView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        VStack {
            TotalView(totalAmount: 0)
            
            HStack {
                Text("Daftar Impian")
                    .font(.callout)
                Spacer()
                SegmentedPickerView(titles: ["Berjalan", "Selesai"], selectedIndex: $selectedIndex)
            }
            .padding(.vertical, 10)
            
            HStack {
                DreamItem( dream: Dreams.dummyData[0])
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        
    }
}

#Preview {
    NotLoggedView()
}
