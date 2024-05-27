//
//  AnggotaView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 27/05/24.
//

import SwiftUI

struct AnggotaView: View {
    
    var selectedEmoticonURL: URL?
    var name: String
    var created: Int64
  
    var body: some View {
        VStack {
            HStack {
                if let url = selectedEmoticonURL {
                    EmoticonItem(url: .constant(url))
                        .frame(width: 60, height: 60)
                }
                
                Text(name)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    AnggotaView(name: "Holiday", created: 1769000000)
}
