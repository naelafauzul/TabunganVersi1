//
//  ProgressBar.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 27/03/24.
//

import SwiftUI

import SwiftUI

struct ProgressBar: View {
    
    @State var isShowing = false
    var amount: CGFloat
    var target: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color.gray)
                .opacity(0.3)
                .frame(width: 300.0, height: 3)
            Rectangle()
                .foregroundColor(Color.blue)
                .frame(width: self.isShowing ? (self.amount >= self.target ? 300.0 : 300.0 * (self.amount / self.target)) : 0.0, height: 3)
                .animation(.linear, value: 0.6)
        }
        .onAppear {
            self.isShowing = true
        }
        .cornerRadius(4.0)
    }
}




#Preview {
    ProgressBar(amount: 250, target: 900)
}
