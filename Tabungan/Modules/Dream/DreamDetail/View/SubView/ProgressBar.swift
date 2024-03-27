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
    var progress: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color.gray)
                .opacity(0.3)
                .frame(minWidth: 200.0, minHeight: 3)
            Rectangle()
                .foregroundColor(Color.blue)
                .frame(width: self.isShowing ? 200.0 * (self.progress / 100.0) : 0.0, height: 3)
                .animation(.linear(duration: 0.6))
        }
        .onAppear {
            self.isShowing = true
        }
        .cornerRadius(4.0)
    }
}


#Preview {
    ProgressBar(progress: 25.0)
}
