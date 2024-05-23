//
//  DestinationView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 23/05/24.
//

import SwiftUI

struct EditProfileView: View {
    var body: some View {
        Text("Edit Profile Page")
            .font(.largeTitle)
            .navigationTitle("Ubah Profil")
    }
}

struct ShareAppView: View {
    var body: some View {
        Text("Share App Page")
            .font(.largeTitle)
            .navigationTitle("Bagikan Aplikasi")
    }
}

struct RateAppView: View {
    var body: some View {
        Text("Rate App Page")
            .font(.largeTitle)
            .navigationTitle("Nilai Aplikasi")
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        Text("Privacy Policy Page")
            .font(.largeTitle)
            .navigationTitle("Kebijakan Privasi")
    }
}

struct SignOutView: View {
    @Binding var userData: UserData?
    
    var body: some View {
        VStack {
            Text("Signing out...")
                .onAppear {
                    Task {
                        do {
                            try await AuthAPIService.shared.signOut()
                            self.userData = nil
                        } catch {
                            print("Unable to sign out")
                        }
                    }
                }
        }
    }
}

