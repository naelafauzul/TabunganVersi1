//
//  AturTargetView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 07/06/24.
//

import SwiftUI

struct AturTargetView: View {
    @EnvironmentObject var DreamDetailViewModel: DreamDetailVM
    @State private var target: Double?
    
    var userId: String
    var dreamId: String
    var initialTarget: Double
    
    var body: some View {
        VStack {
            CustomTextFieldDouble(text: $target, placeholder: "Target", formatter: NumberFormatter())
                .padding(.horizontal, 16)
                .padding(.vertical, 3)
                .onAppear {
                    target = initialTarget
                }
            
            Button {
                Task {
                    do {
                        try await DreamDetailViewModel.aturTarget(userId: userId, dreamid: dreamId, target: target ?? 0.0)
                    } catch {
                        print("can't atur target \(error)")
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Simpan")
                        .foregroundStyle(.white)
                    Spacer()
                }
                
            }
            .padding()
            .frame(height: 50)
            .background(Color.teal700)
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
    }
}

#Preview {
    AturTargetView(userId: "123", dreamId: "123", initialTarget: 10000)
        .environmentObject(DreamDetailVM())
}
