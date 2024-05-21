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
    @ObservedObject var DreamsVM = DreamsViewModel()
    
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
    
    let progress: CGFloat = 0.0
    var dream: Dreams
    
    var dreamTemp: Dreams {
        DreamsVM.dreams.first(where: { $0.id == dream.id }) ?? dream
    }
    
    func updateEmoticonURL() async throws {
        selectedEmoticonURL = EmoticonService.getEmoticonURL(for: dreamTemp.profile)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    ZStack {
                        VStack {
                            //                            if selectedEmoticonURL != nil {
                            //                                EmoticonItem(url: $selectedEmoticonURL)
                            //                                    .frame(width: 60, height: 60)
                            
                            if let emoticon = EmoticonService.getEmoticon(byKey: dream.profile) {
                                SVGImage(url: emoticon.path)
                                    .frame(width: 60, height: 60)
                                
                            } else {
                                Image(systemName: "photo")
                                    .foregroundStyle(.black)
                                    .frame(width: 60, height: 60)
                                
                            }
                            Text(dreamTemp.name)
                                .foregroundStyle(.white)
                                .font(.headline)
                            
                            Text(DreamDetailVewModel.formatCurrency(dreamTemp.target))
                                .foregroundStyle(.white)
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
                                                Text("User")
                                                    .font(.callout)
                                                Spacer()
                                                Text("\(DreamDetailVewModel.formatCurrency(dreamTemp.amount)) / \(DreamDetailVewModel.formatCurrency(dreamTemp.amount))")
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
                    Task {
                        try await DreamDetailVewModel.fetchBillHistory(for: dream.id)
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Konfirmasi Penghapusan", isPresented: $showDeleteConfirmation) {
                Button("Hapus", role: .destructive) {
                    Task {
                        try await DreamDetailVewModel.deleteDream(dreamId: dream.id, userId: userData.uid)
                    }
                }
                Button("Batal", role: .cancel) { }
            } message: {
                Text("Apakah Anda yakin ingin menghapus impian \(dream.name)?")
            }
            .toolbar {
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
            .sheet(isPresented: $showModal) {
                AmountInputView(credit: $credit, operation: $operation, note: $note, uid: userData.uid, dreamId: dream.id, amount: dream.amount, onComplete: {
                    Task {
                        try await DreamDetailVewModel.fetchBillHistory(for: dream.id)
                        try await DreamsVM.fetchDreams(for: userData.uid)
                    }
                })
                .presentationDetents([.large, .medium, .fraction(0.5)])
            }
            .sheet(isPresented: $showUpdateModal) {
                UpdateDreamForm(userData: userData, user: Users(id: "", email: "", profile: "", name: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0), dream: dreamTemp,
                                onComplete: {
                    Task {
                        try await DreamsVM.fetchDreams(for: userData.uid)
                        try await DreamDetailVewModel.fetchBillHistory(for: dream.id)
                        
                    }
                }
                )
            }
        }
    }
}

//#Preview {
//    DetailDream(tabBarVisibility: .constant(.hidden), userData: UserData(uid: "123", email: "helo"), dream: Dreams.dummyData[0], selectedDream: )
//}
