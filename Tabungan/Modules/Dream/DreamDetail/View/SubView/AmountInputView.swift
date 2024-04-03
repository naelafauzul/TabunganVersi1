//
//  AmountInputView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 02/04/24.
//

import SwiftUI

struct AmountInputView: View {
    @StateObject var DreamDetailVewModel = DreamDetailVM()
    @Environment(\.dismiss) var dismiss
    
    @Binding var credit: Double?
    @Binding var operation: String
    @Binding var note: String
    var uid: String
    var dreamId: String
    var amount: Double
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(operation == "Tambah" ? "Isi Tabungan" : "Ambil Tabungan")
                .font(.headline)
            
            CustomTextFieldDouble(text: $credit, placeholder: "Nominal", formatter: NumberFormatter())
                .padding()
            
            CustomTextFieldString(text: $note, placeholder: "Note")
            
            Button(action: {
                if operation == "Tambah" {
                    Task {
                        do {
                            try await DreamDetailVewModel.addCredit(uid: uid, dreamId: dreamId, type: 0, amount: amount, credit: credit ?? 0.0, note: note)
                            dismiss()
                        } catch {
                            print(error)
                        }
                    }
                } else if operation == "Kurang" {
                    Task {
                        do {
                            try await DreamDetailVewModel.subCredit(uid: uid, dreamId: dreamId, type: 1, amount: amount, credit: credit ?? 0.0, note: note)
                            dismiss()
                        } catch {
                            print(error)
                        }
                    }
                }
            }) {
                Text(operation)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.teal700))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 16)
    }
}




//#Preview {
//    AmountInputView(newAmount: <#Binding<String>#>, operation: <#String#>)
//}
