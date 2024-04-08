//
//  TotalView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct TotalView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Anda Telah Menabung")
                    .font(.title2)
                Spacer()
            }
           
            Text("Rp0")
                .font(.title)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    TotalView()
}
