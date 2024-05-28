//
//  DetailDream.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 27/03/24.
//

import SwiftUI
import SVGKit

struct DetailDream: View {
    @EnvironmentObject var DreamDetailVewModel: DreamDetailVM
    @StateObject var DreamsVM: DreamsViewModel
    
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
    
    let progress: CGFloat = 0.0
    
    var body: some View {
        NavigationStack{
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
                            
                            Text(DreamDetailVewModel.formatCurrency(dreamTemp.target))
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
                                            Text(DreamDetailVewModel.formatCurrency(dreamTemp.target))
                                                .font(.callout)
                                        }
                                        
                                        ProgressBar(amount: dreamTemp.amount, target: dreamTemp.target)
                                    }
                                    .foregroundStyle(.black)
                                    
                                    HStack {
                                        Image(systemName: "person")
                                            .frame(width: 30, height: 30)
                                            .background(.gray.opacity(0.3))
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .trailing) {
                                            HStack {
                                                if let username = username {
                                                    Text(username)
                                                        .font(.callout)
                                                }
                                                Spacer()
                                                Text("\(DreamDetailVewModel.formatCurrency(dreamTemp.amount)) / \(DreamDetailVewModel.formatCurrency(dreamTemp.target))")
                                                    .font(.callout)
                                                    .foregroundStyle(.black)
                                            }
                                            ProgressBar(amount: dreamTemp.amount, target: dreamTemp.target)
                                        }
                                    }
                                    .padding(.top, 10)
                                }
                                .padding()
                            }
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                            
                            HStack {
                                GeometryReader { geometry in
                                    HStack {
                                        VStack {
                                            Text(DreamDetailVewModel.formatCurrency(dreamTemp.schedulerRate ?? 0.0))
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
                                            let targetDate = DreamDetailVewModel.calculateTargetDate(target: dreamTemp.target, scheduler: dreamTemp.scheduler, schedulerRate: dreamTemp.schedulerRate ?? 0.0, amount: dreamTemp.amount)
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
                    
                    List(DreamDetailVewModel.historyList) { billHistory in
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
                        Text("- Kurang")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        operation = "Tambah"
                        showModal.toggle()
                    } label: {
                        Text("+ Tambah")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .onAppear {
                    tabBarVisibility = .hidden
                    Task {
                        try await fetchDreamDetailData()
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
                        try await DreamDetailVewModel.deleteDream(dreamId: dreamTemp.id, userId: userData.uid)
                    }
                }
                Button("Batal", role: .cancel) { }
            } message: {
                Text("Kamu tidak akan bisa melihat impian ini lagi")
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AnggotaView(DreamDetailViewModel: DreamDetailVewModel, selectedEmoticonURL: selectedEmoticonURL, name: dreamTemp.name, created: dreamTemp.created, dreamId: dreamTemp.id, userId: dreamTemp.userId ?? "")) {
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
                AmountInputView(credit: $credit, operation: $operation, note: $note, uid: userData.uid, dreamId: dreamTemp.id, amount: dreamTemp.amount, onComplete: {
                    Task {
                        try await updateDreamDetail()
                    }
                })
                .presentationDetents([.large, .medium, .fraction(0.4)])
            }
            .sheet(isPresented: $showUpdateModal) {
                UpdateDreamForm(userData: userData, user: Users(id: "", email: "", profile: "", name: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0), dream: dreamTemp,
                                onComplete: {
                    Task {
                        try await updateDreamDetail()
                    }
                })
            }
        }
    }
    
    func fetchDreamDetailData() async throws {
        try await DreamDetailVewModel.fetchBillHistory(for: dreamTemp.id)
        username = try await DreamDetailVewModel.fetchUserName(for: userData.uid)
        updateEmoticonURL()
    }
    
    
    func updateDreamDetail() async throws {
        try await DreamDetailVewModel.fetchBillHistory(for: dreamTemp.id)
        try await DreamsVM.fetchDreams(for: userData.uid)
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

