//
//  DreamItem.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct DreamItem: View {
    @StateObject var CreateDreamsVM = CreateDreamVM()
    let progress: CGFloat = 0.75
    let dream: Dreams
    
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: "photo")
                    .foregroundStyle(.black)
                    .frame(width: 60, height: 60)
                    .background(.white)
                    .clipShape(Circle())
                
                Spacer()
                    
                CircularProgressBar(amount: dream.amount, target: dream.target)
                    .frame(width: 40, height: 40)
            }
         
            
            Spacer()
            
            Text(dream.name)
                .font(.headline)
                .foregroundStyle(.black)
                .lineLimit(1)
                .padding(.bottom, 5)
            Text(CreateDreamsVM.formatCurrency(dream.target))
                .font(.subheadline)
                .foregroundStyle(.black)
                .lineLimit(1)
                .padding(.bottom, 10)
        }
        .padding()
        .frame(width: 170, height: 170)
        .background(Color(hex: dream.background))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
    }
    
    
}

//#Preview {
//    DreamItem( dream: Dreams.dummyData[0])
//}
