//
//  ProfileView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 23/05/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileViewModel = ProfileVM()
    @Binding var userData: UserData?
    
    @State private var showingModal = false
    @State private var code: String = ""
    @State private var joinDreamState: StateView = .idle
    @State var profileImage = Image(systemName: "person")
    
    @State private var navigateToEditProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView (showsIndicators: false) {
                VStack {
                    if let user = profileViewModel.user {
                        if profileImage != Image(systemName: "person") {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person")
                                .frame(width: 80, height: 80)
                                .scaledToFill()
                                .background(.secondary)
                                .clipShape(Circle())
                        }
                        Text(user.name)
                            .font(.title2)
                        
                    } else {
                        Image(systemName: "person")
                            .frame(width: 80, height: 80)
                            .scaledToFill()
                            .background(.secondary)
                            .clipShape(Circle())
                        
                        Text("Kamu Belum Login")
                            .font(.title2)
                    }
                }
                .padding(.top, 30)
                .padding(.bottom, 30)
                .onAppear {
                    if let userData = userData {
                        Task {
                            do {
                                try await profileViewModel.fetchUserInfo(for: userData.uid)
                                let uiImage = try await profileViewModel.fetchProfilePhoto(for: userData.uid )
                                profileImage = Image(uiImage: uiImage)
                            } catch {
                                print("Failed to fetch user info: \(error)")
                            }
                        }
                    }
                }
                
                Group {
                    ProfileItem(image: "square.and.arrow.up.fill", title: "Ubah Profil", description: "Ubah Nama dan Profil")
                        .onTapGesture {
                            navigateToEditProfile = true
                        }
                        .background(
                            NavigationLink(destination: EditProfileView(userData: $userData), isActive: $navigateToEditProfile) {
                                EmptyView()
                            }
                        )
                    ProfileItem(image: "person.fill", title: "Bagikan Aplikasi", description: "Beritahu teman tentang Celenganku")
                    ProfileItem(image: "star.fill", title: "Nilai Aplikasi", description: "Berikan bintang pada Aplikasi Celenganku")
                    ProfileItem(image: "exclamationmark.shield.fill", title: "Kebijakan Privasi", description: "Lihat Kebijakan Privasi")
                    ProfileItem(image: "flag.fill", title: "Sign Out", description: "Keluar dari Aplikasi")
                        .onTapGesture {
                            Task {
                                do {
                                    try await profileViewModel.signOut()
                                    userData = nil
                                } catch {
                                    print("Failed to sign out: \(error)")
                                }
                            }
                        }
                }
                .padding(.vertical, 2)
                
                Button {
                    showingModal.toggle()
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(.white)
                        Text("Gabung Undangan Impian Teman")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                .padding()
                .background(Color.teal700)
                .cornerRadius(8)
                .padding(.top, 30)
                .sheet(isPresented: $showingModal) {
                    if let user = profileViewModel.user {
                        JoinDreamModal(code: $code, userId: user.id, profile: user.profile, name: user.name)
                            .presentationDetents([.large, .medium, .fraction(0.3)])
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ProfileView(userData: .constant(UserData(uid: "123", email: "naela@gmail.com")))
}
