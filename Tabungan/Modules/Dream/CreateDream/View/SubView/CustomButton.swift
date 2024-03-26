//
//  CustomButton.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 20/03/24.
//

import SwiftUI

struct CustomButton: View {
    @Binding var scheduler : String
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                scheduler = "Days"
            }) {
                
                if scheduler == "Days" {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 50, bottomLeading: 50, bottomTrailing: 0, topTrailing: 0))
                            .foregroundStyle(scheduler == "Days" ? Color.teal700 : Color.clear)
                        Text(scheduler == "Days" ? "✓Harian" : "Harian")
                            .foregroundStyle(scheduler == "Days" ? .white : .black)
                    }
                    
                } else {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 50, bottomLeading: 50, bottomTrailing: 0, topTrailing: 0))
                            .stroke(.teal700)
                        Text("Harian")
                            .foregroundStyle(.black)
                    }
                    
                }
            }
            .frame(width: .infinity, height: 40)
            
            Button(action: {
                scheduler = "Weeks"
            }) {
                
                if scheduler == "Weeks" {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 0, topTrailing: 0))
                            .foregroundStyle(scheduler == "Weeks" ? Color.teal700 : Color.clear)
                        Text(scheduler == "Weeks" ? "✓Mingguan" : "Mingguan")
                            .foregroundStyle(scheduler == "Weeks" ? .white : .black)
                    }
                    
                } else {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 0, topTrailing: 0))
                            .stroke(.teal700)
                        Text("Mingguan")
                            .foregroundStyle(.black)
                    }
                    
                }
            }
            .frame(width: .infinity, height: 40)
            
            
            
            Button(action: {
                scheduler = "Month"
            }) {
                
                if scheduler == "Month" {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 50, topTrailing: 50))
                            .foregroundStyle(scheduler == "Month" ? Color.teal700 : Color.clear)
                        Text(scheduler == "Month" ? "✓Bulanan" : "Bulanan")
                            .foregroundStyle(scheduler == "Month" ? .white : .black)
                    }
                    
                } else {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 0, bottomTrailing: 50, topTrailing: 50))
                            .stroke(.teal700)
                        Text("Bulanan")
                            .foregroundStyle(.black)
                    }
                    
                }
            }
            .frame(width: .infinity, height: 40)
        }
    }
}
//
//#Preview {
//    CustomButton(scheduler: )
//}
