//
//  AmountInputView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 02/04/24.
//
import SwiftUI

import SwiftUI

struct AmountInputView: View {
    @StateObject var DreamDetailVewModel = DreamDetailVM()
    
    var uid: String
    @Binding var credit: String
    @Binding var operation: String
    var dreamId: String
    var amount: Double
    
    var body: some View {
        VStack {
            TextField("Jumlah", text: $credit)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding()
            
            Button(action: {
                if operation == "Tambah" {
                    Task {
                        do {
                            try await DreamDetailVewModel.addCredit(uid: uid, dreamId: dreamId, type: 0, amount: amount, credit: Double(credit) ?? 0.0)
                        } catch {
                            print(error)
                        }
                    }
                } else if operation == "Kurang" {
                    Task {
                        do {
                            try await DreamDetailVewModel.subCredit(uid: uid, dreamId: dreamId, type: 1, amount: amount, credit: Double(credit) ?? 0.0)
                        } catch {
                            print(error)
                        }
                    }
                }
            }) {
                Text(operation)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }
}



//
//#Preview {
//    AmountInputView(newAmount: <#Binding<String>#>, operation: <#String#>)
//}
