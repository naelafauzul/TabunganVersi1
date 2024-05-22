//
//  SegmentedPickerView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 22/05/24.
//

import SwiftUI

struct SegmentedPickerView: View {
    let titles: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        HStack {
            ForEach(titles.indices, id: \.self) { index in
                VStack {
                    Text(titles[index])
                        .font(.footnote)
                        .foregroundColor(selectedIndex == index ? .teal700 : .gray)
                        .padding(.horizontal, 2)
                        .onTapGesture {
                            withAnimation {
                                selectedIndex = index
                            }
                        }
                    
                    Rectangle()
                        .fill(selectedIndex == index ? Color.teal700 : Color.clear)
                        .frame(width: 50, height: 3)
                        .cornerRadius(10)
                }
                
            }
        }
        .padding(.horizontal)
    }
}


#Preview {
    SegmentedPickerView(titles: ["Berjalan", "Selesai"], selectedIndex: .constant(0))
}

