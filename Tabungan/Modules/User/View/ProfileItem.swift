//
//  ProfileItem.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 23/05/24.
//

import SwiftUI

struct ProfileItem: View {
    var image: String
    var title: String
    var description: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .foregroundColor(.black)
                .frame(width: 40, height: 40)
                .background(.purple.opacity(0.1))
                .clipShape(Circle())
            
            VStack (alignment: .leading) {
                Text(title)
                    .font(.footnote)
                    .padding(.bottom, 1)
                Text(description)
                    .font(.caption2)
            }
            .padding(.leading, 8)
        }
    }
}

#Preview {
    ProfileItem(image: "person.fill", title: "Ubah Profil", description: "Ubah Nama dan Profil")
}
