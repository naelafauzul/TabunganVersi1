//
//  DreamItem.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI
import SVGKit

struct DreamItem: View {
    @StateObject var CreateDreamsVM = CreateDreamVM()
    let progress: CGFloat = 0.75
    let dream: Dreams

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let emoticon = EmoticonService.getEmoticon(byKey: dream.profile) {
                    SVGImage(url: emoticon.path)
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo")
                        .foregroundStyle(.black)
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                
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


#Preview {
    DreamItem( dream: Dreams.dummyData[0])
}
