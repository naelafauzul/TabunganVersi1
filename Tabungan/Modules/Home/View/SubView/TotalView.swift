//
//  TotalView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct TotalView: View {
    var totalAmount = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Anda Telah Menabung")
                    .font(.headline)
                Spacer()
            }
           
            Text("Rp\(totalAmount)")
                .font(.title)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    TotalView()
}
