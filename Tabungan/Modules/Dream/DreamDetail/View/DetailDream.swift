//
//  DetailDream.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 27/03/24.
//

import SwiftUI
import SVGKit

struct DetailDream: View {
    @EnvironmentObject var DreamDetailViewModel: DreamDetailVM
    @StateObject var DreamsVM: DreamsViewModel
    @StateObject private var profileViewModel = ProfileVM()
    
    @Environment(\.dismiss) var dismiss
    @Binding var tabBarVisibility: Visibility
    
    @State private var showDeleteConfirmation = false
    @State private var showModal = false
    @State private var showUpdateModal = false
    @State private var credit: Double? = nil
    @State private var operation: String = ""
    @State private var note: String = ""
    @State var userData: UserData
    @State private var selectedEmoticonURL: URL? = nil
    @State private var username: String? = nil
    @State var dreamTemp: Dreams
    @State private var showConfetti = false
    
    let progress: CGFloat = 0.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        ZStack {
                            VStack {
                                if selectedEmoticonURL != nil {
                                    EmoticonItem(url: $selectedEmoticonURL)
                                        .frame(width: 60, height: 60)
                                } else {
                                    Image(systemName: "photo")
                                        .foregroundStyle(.black)
                                        .frame(width: 60, height: 60)
                                }
                                
                                Text(dreamTemp.name)
                                    .foregroundStyle(.black)
                                    .font(.headline)
                                
                                Text(DreamDetailViewModel.formatCurrency(dreamTemp.amount))
                                    .foregroundStyle(.black)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                VStack {
                                    VStack(alignment: .trailing) {
                                        VStack(alignment: .trailing) {
                                            HStack {
                                                Text("Target")
                                                    .font(.callout)
                                                Spacer()
                                                Text(DreamDetailViewModel.formatCurrency(dreamTemp.target))
                                                    .font(.callout)
                                            }
                                            
                                            ProgressBar(amount: dreamTemp.amount, target: dreamTemp.target)
                                        }
                                        .foregroundStyle(.black)
                                        
                                        ScrollView {
                                            ForEach(DreamDetailViewModel.dreamUsers) { user in
                                                HStack {
                                                    if let profilePhoto = profileViewModel.profilePhotos[user.userId] {
                                                        Image(uiImage: profilePhoto)
                                                            .resizable()
                                                            .frame(width: 30, height: 30)
                                                            .background(.gray.opacity(0.3))
                                                            .clipShape(Circle())
                                                    } else {
                                                        Image(systemName: "person.crop.circle")
                                                            .resizable()
                                                            .frame(width: 30, height: 30)
                                                            .background(.gray.opacity(0.3))
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
                                                    
                                                    VStack(alignment: .trailing) {
                                                        HStack {
                                                            Text(user.name)
                                                                .font(.callout)
                                                            Spacer()
                                                            Text("\(DreamDetailViewModel.formatCurrency(user.amount)) / \(DreamDetailViewModel.formatCurrency(user.target))")
                                                                .font(.callout)
                                                                .foregroundStyle(.black)
                                                                .lineLimit(1)
                                                        }
                                                        ProgressBar(amount: dreamTemp.amount, target: user.target)
                                                    }
                                                }
                                                .padding(.top, 10)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .frame(minHeight: 170, maxHeight: 180)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal, 16)
                                .padding(.top, 20)
                                
                                HStack {
                                    GeometryReader { geometry in
                                        HStack {
                                            VStack {
                                                Text(DreamDetailViewModel.formatCurrency(dreamTemp.schedulerRate ?? 0.0))
                                                    .font(.callout)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(.blue)
                                                Text(dreamTemp.scheduler)
                                                    .font(.footnote)
                                            }
                                            .padding(.vertical, 10)
                                            .frame(width: geometry.size.width / 2 - 5)
                                            .background(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                            VStack {
                                                let targetDate = DreamDetailViewModel.calculateTargetDate(target: dreamTemp.target, scheduler: dreamTemp.scheduler, schedulerRate: dreamTemp.schedulerRate ?? 0.0, amount: dreamTemp.amount)
                                                Text(targetDate)
                                                    .font(.callout)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(.blue)
                                                Text("Estimasi Tercapai")
                                                    .font(.footnote)
                                            }
                                            .padding(.vertical, 10)
                                            .frame(width: geometry.size.width / 2 - 5)
                                            .background(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .clipShape(Rectangle())
                            .background(Color(hex: dreamTemp.background))
                        }
                    }
                    .frame(height: 400)
                    
                    VStack {
                        HStack {
                            Text("Riwayat")
                                .font(.callout)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 3)
                        
                        List(DreamDetailViewModel.historyList) { billHistory in
                            HistoryItem(billHistory: billHistory)
                        }
                        .listStyle(.plain)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            operation = "Kurang"
                            showModal.toggle()
                        } label: {
                            HStack {
                                Spacer()
                                Text("- Kurang")
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                        }
                        .padding()
                        .frame(height: 40)
                        .background(Color.red)
                        .cornerRadius(8)
                        
                        Button {
                            operation = "Tambah"
                            showModal.toggle()
                        } label: {
                            HStack {
                                Spacer()
                                Text("+ Tambah")
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                        }
                        .padding()
                        .frame(height: 40)
                        .background(Color.teal700)
                        .cornerRadius(8)
                    }
                    .padding(.bottom, 5)
                    .padding(.horizontal, 16)
                    .onAppear {
                        tabBarVisibility = .hidden
                        Task {
                            try await fetchDreamDetailData()
                            if dreamTemp.amount >= dreamTemp.target {
                                showConfetti = true
                            }
                        }
                    }
                    .onDisappear {
                        tabBarVisibility = .visible
                        Task {
                            try await fetchDreamDetailData()
                            try await DreamsVM.fetchDreams(for: userData.uid)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .alert("Hapus impian \(dreamTemp.name)?", isPresented: $showDeleteConfirmation) {
                    Button("Hapus", role: .destructive) {
                        Task {
                            try await DreamDetailViewModel.deleteDream(dreamId: dreamTemp.id, userId: userData.uid)
                        }
                    }
                    Button("Batal", role: .cancel) { }
                } message: {
                    Text("Kamu tidak akan bisa melihat impian ini lagi")
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AnggotaView(DreamDetailViewModel: DreamDetailViewModel, selectedEmoticonURL: selectedEmoticonURL, name: dreamTemp.name, created: dreamTemp.created, dreamId: dreamTemp.id, userId: dreamTemp.userId ?? "")) {
                            Text("Anggota")
                                .font(.subheadline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                .background(.white)
                                .cornerRadius(50)
                        }
                        
                        Menu {
                            Button {
                                showUpdateModal.toggle()
                            } label: {
                                Label("Ubah", systemImage: "pencil")
                            }
                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                                .rotationEffect(.degrees(90))
                        }
                    }
                }
                .sheet(isPresented: $showModal) {
                    AmountInputView(credit: $credit, operation: $operation, note: $note, uid: userData.uid, dreamId: dreamTemp.id, amount: DreamDetailViewModel.userAmount.first?.amount, onComplete: {
                        Task {
                            try await updateDreamDetail()
                            if dreamTemp.amount >= dreamTemp.target {
                                showConfetti = true
                            }
                        }
                    })
                    .presentationDetents([.large, .medium, .fraction(0.4)])
                }
                .sheet(isPresented: $showUpdateModal) {
                    UpdateDreamForm(userData: userData, user: Users(id: "", email: "", profile: "", name: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0), dream: dreamTemp,
                                    onComplete: {
                        Task {
                            try await updateDreamDetail()
                            if dreamTemp.amount >= dreamTemp.target {
                                showConfetti = true
                            }
                        }
                    })
                }
                
                if showConfetti {
                    ConfettiUIView(direction: .bottom, animation: .default)
                        .allowsHitTesting(false) // Menonaktifkan interaksi pada ConfettiUIView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
    
    func fetchDreamDetailData() async throws {
        try await DreamDetailViewModel.fetchDreamUsers(for: dreamTemp.id)
        try await DreamDetailViewModel.fetchBillHistory(for: dreamTemp.id)
        try await DreamDetailViewModel.getUserAmount(dreamId: dreamTemp.id, userId: userData.uid)
        for user in DreamDetailViewModel.anggotaDreamUsers {
            let profilePhoto = try await profileViewModel.fetchProfilePhoto(for: user.userId)
            profileViewModel.profilePhotos[user.userId] = profilePhoto
        }
        username = try await DreamDetailViewModel.fetchUserName(for: userData.uid)
        updateEmoticonURL()
    }
    
    func updateDreamDetail() async throws {
        try await DreamDetailViewModel.fetchBillHistory(for: dreamTemp.id)
        try await DreamsVM.fetchDreams(for: userData.uid)
        try await DreamDetailViewModel.fetchDreamUsers(for: dreamTemp.id)
        try await DreamDetailViewModel.getUserAmount(dreamId: dreamTemp.id, userId: userData.uid)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let updatedDream = DreamsVM.dreams.first(where: { $0.id == dreamTemp.id }) {
                dreamTemp = updatedDream
            }
            updateEmoticonURL()
        }
    }
    
    func updateEmoticonURL() {
        selectedEmoticonURL = EmoticonService.getEmoticonURL(for: dreamTemp.profile)
    }
}

#Preview {
    DetailDream(
        DreamsVM: DreamsViewModel(), tabBarVisibility: .constant(.hidden),
        userData: UserData(uid: "123", email: "example@example.com"),
        dreamTemp: Dreams(id: "1", userId: "Dream Vacation", code: "ABC123", profile: "image", background: "#FFDD93", name: "Holiday", target: 100.0, amount: 10.0, isActive: true, created: 123, updated: 234, scheduler: "month", schedulerRate: 10.0)
    )
}
