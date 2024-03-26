//
//  CustomColorPicker.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct CustomColorPicker: View {
    @Binding var selectedColor: String
    
    let colors: [String] = [
        "#F2C4DE", "#71B1D9", "#AED8F2", "#F2DEA2", "#F2CDC4",
        "#ABD3DB", "#C2E6DF", "#D1EBD8", "#E5F5DC", "#FFFFE1",
        "#F2D0D9", "#F2F2F2", "#B8C6D9", "#8596A6", "#F2D9D0",
        "#A9B5D9", "#F2A477", "#F29472", "#F2C4C4", "#D9EDF8",
        "#F0F2F2", "#D9C4B8", "#F2DDD0", "#F2B2AC", "#F2A0A0",
        "#365359", "#91D2D9", "#BFD9D6", "#A3D9CF", "FFADAD",
        "#D9BCF2", "#FEF4FF", "#EEBFD9", "#FFA6C3", "#D4F5DD",
        "#F2DFEB", "#AEDFF2", "#72DBF2", "#F2C879", "#F2D8A7",
        "#8990B3", "#FFD3C4", "#DEE3FF", "#DEFFC4", "#A0B392",
    ]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    
    var body: some View {
        NavigationStack {
            ScrollView (showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(colors, id: \.self) { color in
                        Button(action: {
                            self.selectedColor = color
                        }) {
                            Image(systemName: self.selectedColor == color ? "checkmark.circle.fill" : "circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .accentColor(Color(hex: color))
                        }
                    }
                }
            }
        }
        .padding(20)
    }
}



