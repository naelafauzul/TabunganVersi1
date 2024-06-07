//
//  AnggotaView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 27/05/24.
//

import SwiftUI

struct AnggotaView: View {
    @ObservedObject var DreamDetailViewModel: DreamDetailVM
    @StateObject private var profileViewModel = ProfileVM()
    
    var selectedEmoticonURL: URL?
    var name: String
    var created: Int64
    var dreamId: String
    var userId: String
    
    @State private var showAturTarget = false
    @State private var selectedUser: DreamUsers? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = selectedEmoticonURL {
                    EmoticonItem(url: .constant(url))
                        .frame(width: 70, height: 70)
                } else {
                    Image(systemName: "photo")
                        .frame(width: 70, height: 70)
                        .background(Color.purple.opacity(0.1))
                        .clipShape(Circle())
                }
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                    Text("Dibuat pada \(DreamDetailViewModel.formatDateWithYear(from: created))")
                }
                .padding(.leading, 10)
                
                Spacer()
                
            }
            .padding(.bottom, 30)
            .padding(.top, 20)
            
            Text("Admin")
                .font(.headline)
                .padding(.bottom, 10)
            
            if let admin = DreamDetailViewModel.adminDreamUsers.first {
                HStack {
                    if let profilePhoto = profileViewModel.profilePhotos[admin.userId] {
                        Image(uiImage: profilePhoto)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(Color.purple.opacity(0.1))
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                            .task {
                                do {
                                    let profilePhoto = try await profileViewModel.fetchProfilePhoto(for: admin.userId)
                                    profileViewModel.profilePhotos[admin.userId] = profilePhoto
                                } catch {
                                    print("Error fetching profile photo: \(error)")
                                }
                            }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(admin.name)
                            .font(.callout)
                        Text("Target: \(DreamDetailViewModel.formatCurrency(admin.target))")
                            .font(.subheadline)
                    }
                    .padding(.leading, 10)
                }
                .padding(.bottom, 10)
            }
            
            Text("Anggota")
                .font(.headline)
                .padding(.top, 30)
                .padding(.bottom, 10)
            
            ForEach(DreamDetailViewModel.anggotaDreamUsers) { user in
                HStack {
                    if let profilePhoto = profileViewModel.profilePhotos[user.userId] {
                        Image(uiImage: profilePhoto)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(Color.purple.opacity(0.1))
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                            .task {
                                do {
                                    let profilePhoto = try await profileViewModel.fetchProfilePhoto(for: user.userId)
                                    profileViewModel.profilePhotos[user.userId] = profilePhoto
                                } catch {
                                    print("Error fetching profile photo: \(error)")
                                }
                            }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.callout)
                        Text("Target: \(DreamDetailViewModel.formatCurrency(user.target))")
                            .font(.subheadline)
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            selectedUser = user
                            showAturTarget.toggle()
                        } label: {
                            Label("Atur target", systemImage: "pencil")
                        }
                        Button(action: {
                            // Aksi untuk menghapus anggota
                        }) {
                            Label("Hapus anggota", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                            .rotationEffect(.degrees(90))
                    }
                }
                .padding(.bottom, 10)
            }
            
            Spacer()
            
            let shareMessage = """
                        Download aplikasi Celenganku https://www.celenganku.com
                        2. Daftar menggunakan Google
                        3. Klik menu Akun, dan klik menu Gabung
                        4. Masukkan kode dibawah ini:
                        
                        \(dreamId)
                        """
            
            ShareLink(
                item: "Saya mengundangmu untuk bergabung di impianku. Caranya: \n1.",
                subject: Text("Undangan Bergabung di Impian"),
                message: Text(shareMessage)
            ) {
                HStack {
                    Spacer()
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.white)
                    Text("Tambah Anggota")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding()
            .background(Color.teal700)
            .cornerRadius(8)
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 16)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Anggota Impian")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                try await DreamDetailViewModel.fetchAnggotaDreamUsers(for: dreamId, excludeUserId: userId)
                try await DreamDetailViewModel.fetchAdminDreamUsers(for: dreamId, userId: userId)
                
                for user in DreamDetailViewModel.anggotaDreamUsers {
                    let profilePhoto = try await profileViewModel.fetchProfilePhoto(for: user.userId)
                    profileViewModel.profilePhotos[user.userId] = profilePhoto
                }
            } catch {
                print("Error fetching users: \(error)")
            }
        }
        .sheet(isPresented: $showAturTarget) {
            if let user = selectedUser {
                AturTargetView(userId: user.userId, dreamId: dreamId, initialTarget: user.target)
                    .environmentObject(DreamDetailViewModel)
            }
        }
    }
}

#Preview {
    AnggotaView(DreamDetailViewModel: DreamDetailVM(), name: "Holiday", created: 1999000000, dreamId: "123", userId: "123")
}
