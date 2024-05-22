//
//  UserView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import SwiftUI

struct UserView: View {
    @StateObject private var userViewModel = UserVM()
    @Binding var userData: UserData?
    
    var body: some View {
        if let userData = userData {
            VStack {
                VStack {
                    Text(userData.uid)
                    Text(userData.email)
                    if let user = userViewModel.user {
                        Text(user.gender)
                    } else {
                        Text("Loading...")
                    }
                }
                Button {
                    Task {
                        do {
                            try await AuthAPIService.shared.signOut()
                            self.userData = nil
                        } catch {
                            print("Unable to sign out")
                        }
                    }
                } label: {
                    Text("Sign Out")
                }
                .buttonStyle(.borderedProminent)
            }
            .onAppear {
                Task {
                    do {
                        try await userViewModel.fetchUserInfo(for: userData.uid)
                    } catch {
                        print("Failed to fetch user info: \(error)")
                    }
                }
            }
        } else {
            Text("You are not logged in")
        }
    }
}

#Preview {
    UserView(userData: .constant(.init(uid: "123", email: "hai@gmail.com")))
}
