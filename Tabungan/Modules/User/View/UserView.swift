//
//  UserView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import SwiftUI

struct UserView: View {
    @Binding var userData: UserData?
    
    var body: some View {
        if let userData = userData {
            VStack {
                VStack {
                    Text(userData.uid)
                    Text(userData.email)
             
                }
                Button {
                    Task {
                        do {
                            try await AuthAPIService.shared.signOut()
                            self.userData = nil
                        } catch {
                            print("unable to sign out")
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
                        try await DreamsViewModel().fetchDream(for: userData.uid)
                        
                    } catch {
                        print(error)
                    }
                }
            }
            
        } else {
            Text("kamu belum login")
        }
    }
}

#Preview {
    UserView(userData: .constant(.init(uid: "123", email: "hai@gmail.com")))
}
