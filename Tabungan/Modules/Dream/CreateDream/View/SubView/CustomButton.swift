//
//  CustomButton.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 20/03/24.
//

import SwiftUI

struct CustomButton: View {
    @Binding var scheduler: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                scheduler = "Days"
            }) {
                ZStack {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 50, bottomLeading: 50, bottomTrailing: 0, topTrailing: 0))
                        .foregroundStyle(scheduler == "Days" ? Color.teal700 : Color.clear)
                    Text(scheduler == "Days" ? "✓Harian" : "Harian")
                        .foregroundStyle(scheduler == "Days" ? .white : .black)
                        .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: 80)
                .overlay(
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 50, bottomLeading: 50, bottomTrailing: 0, topTrailing: 0))
                        .stroke(scheduler == "Days" ? Color.clear : Color.teal700)
                )
            }

            Button(action: {
                scheduler = "Weeks"
            }) {
                ZStack {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 0, topTrailing: 0))
                        .foregroundStyle(scheduler == "Weeks" ? Color.teal700 : Color.clear)
                    Text(scheduler == "Weeks" ? "✓Mingguan" : "Mingguan")
                        .foregroundStyle(scheduler == "Weeks" ? .white : .black)
                        .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: 80)
                .overlay(
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 0, topTrailing: 0))
                        .stroke(scheduler == "Weeks" ? Color.clear : Color.teal700)
                )
            }

            Button(action: {
                scheduler = "Month"
            }) {
                ZStack {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 50, topTrailing: 50))
                        .foregroundStyle(scheduler == "Month" ? Color.teal700 : Color.clear)
                    Text(scheduler == "Month" ? "✓Bulanan" : "Bulanan")
                        .foregroundStyle(scheduler == "Month" ? .white : .black)
                        .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: 80)
                .overlay(
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 50, topTrailing: 50))
                        .stroke(scheduler == "Month" ? Color.clear : Color.teal700)
                )
            }
        }
    }
}

//#Preview {
//    @State var scheduler: String = "Days"
//        CustomButton(scheduler: $scheduler)
//    
//}

