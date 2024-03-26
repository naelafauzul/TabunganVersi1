//
//  TotalView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct TotalView: View {
    @StateObject var DreamsVM = DreamsViewModel()
    var userData: UserData?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Anda Telah Menabung")
                    .font(.title2)
                Spacer()
            }
           
            Text("Rp\(DreamsVM.totalAmount, specifier: "%.0f")")
                .font(.title)
                .fontWeight(.bold)
        }
//        .onAppear {
//            if let userData = userData {
//                Task {
//                    do {
//                        try await DreamsVM.fetchTotalAmount(for: userData.uid)
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//        }
    }
}

#Preview {
    TotalView()
}
