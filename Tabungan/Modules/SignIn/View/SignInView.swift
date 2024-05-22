//
//  AuthView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import SwiftUI

struct SignInView: View {
    @StateObject var signInVM = SignInViewModel()
    @Binding var userData: UserData?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Mendaftar dahulu agar datamu tidak hilang, ya")
                .font(.title2)
                .lineLimit(2, reservesSpace: true)
            Button {
                Task {
                    do {
                        let loggedInUserData = try await signInVM.signInWithGoogle()
                        userData = loggedInUserData // Update userData after successful login
                        dismiss()
                    } catch {
                        print(error)
                    }
                }
            } label : {
                Text("Lanjutkan dengan Google")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, minHeight: 42)
                    .background(.teal700)
                    .cornerRadius(100)
            }
            .padding(.vertical,8)
            
            Spacer()
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
    }
}

#Preview {
    SignInView(userData: .constant(UserData(uid: "", email: "")))
}
