//
//  ProfileView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 23/05/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var userViewModel = UserVM()
    @Binding var userData: UserData?
    
    let profileItems = [
        ProfileItemModel(image: "person.fill", title: "Ubah Profil", description: "Ubah Nama dan Profil"),
        ProfileItemModel(image: "square.and.arrow.up.fill", title: "Bagikan Aplikasi", description: "Beritahu teman tentang Celenganku"),
        ProfileItemModel(image: "star.fill", title: "Nilai Aplikasi", description: "Berikan bintang pada Aplikasi Celenganku"),
        ProfileItemModel(image: "exclamationmark.shield.fill", title: "Kebijakan Privasi", description: "Lihat Kebijakan Privasi"),
        ProfileItemModel(image: "flag.fill", title: "Sign Out", description: "Keluar dari Aplikasi")
    ]
    
    var body: some View {
        NavigationStack {
            VStack() {
                VStack {
                    if userData != nil {
                        if let user = userViewModel.user {
                            Text(user.name)
                                .font(.title2)
                        }
                    } else {
                        Text("Kamu Belum Login")
                            .font(.title2)
                    }
                }
                .padding(.top, 100)
                .padding(.bottom, 50)
                .onAppear {
                    if let userData = userData {
                        Task {
                            do {
                                try await userViewModel.fetchUserInfo(for: userData.uid)
                            } catch {
                                print("Failed to fetch user info: \(error)")
                            }
                        }
                    }
                }
                
                List(profileItems) { item in
                    NavigationLink(destination: destinationView(for: item)) {
                        ProfileItem(image: item.image, title: item.title, description: item.description)
                            .padding(.vertical,10)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        Color.gray.opacity(0.05)
                            .cornerRadius(10)
                            .padding(.vertical, 8)
                    )
                    
                }
                .listStyle(.plain)
                
                Button {
                    
                } label: {
                    Text("Gabung")
                }
                
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func destinationView(for item: ProfileItemModel) -> some View {
        switch item.title {
        case "Ubah Profil":
            EditProfileView()
        case "Bagikan Aplikasi":
            ShareAppView()
        case "Nilai Aplikasi":
            RateAppView()
        case "Kebijakan Privasi":
            PrivacyPolicyView()
        case "Sign Out":
            SignOutView(userData: $userData)
        default:
            Text("Page not found")
        }
    }
}


#Preview {
    ProfileView(userData: .constant(UserData(uid: "123", email: "naela@gmail.com")))
}