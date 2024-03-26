//
//  CircularProgressBar.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct CircularProgressBar: View {
    var amount: CGFloat
    var target: CGFloat
    
    private var progress: CGFloat {
        return target > 0 ? min(amount / target, 1) : 0
    }
    
    var body: some View {
        ZStack {
            Circle()
            
                .stroke(lineWidth: 5.0)
                .foregroundColor(Color.white)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            Text(String(format: "%.0f%%", min(self.progress, 1.0)*100.0))
                .font(.footnote)
        }
    }
}

#Preview {
    CircularProgressBar(amount: 0.5, target: 0.9)
}
