//
//  DetailDream.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 27/03/24.
//

import SwiftUI

struct DetailDream: View {
    @StateObject var DreamDetailVewModel = DreamDetailVM()
    @StateObject var DreamsVM = DreamsViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showModal = false
    @State private var credit: Double? = nil
    @State private var operation: String = ""
    @State private var note: String = ""
    @State var userData: UserData
    
    let progress: CGFloat = 0.0
    let dream: Dreams
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    ZStack {
                        VStack {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 40, height: 30)
                                .padding(.bottom, 20)
                            
                            Text(dream.name)
                                .foregroundStyle(.white)
                                .font(.headline)
                            
                            Text(DreamDetailVewModel.formatCurrency(dream.target))
                                .foregroundStyle(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            VStack{
                                VStack(alignment:.trailing) {
                                    VStack(alignment:.trailing) {
                                        HStack {
                                            Text("Target")
                                                .font(.callout)
                                            Spacer()
                                            Text(DreamDetailVewModel.formatCurrency(dream.target))
                                                .font(.callout)
                                        }
                                        
                                        ProgressBar(amount: dream.amount, target: dream.target)
                                    }
                                    .foregroundStyle(.black)
                                    
                                    
                                    HStack {
                                        Image(systemName: "person")
                                            .frame(width: 30, height: 30)
                                            .background(.gray.opacity(0.3))
                                            .clipShape(Circle())
                                        
                                        VStack (alignment:.trailing) {
                                            HStack {
                                                Text("User")
                                                    .font(.callout)
                                                Spacer()
                                                Text("\(DreamDetailVewModel.formatCurrency(dream.amount)) / \(DreamDetailVewModel.formatCurrency(dream.amount))")
                                                    .font(.callout)
                                                    .foregroundStyle(.black)
                                                
                                            }
                                            ProgressBar(amount: dream.amount, target: dream.target)
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
                                    HStack{
                                        VStack {
                                            Text(DreamDetailVewModel.formatCurrency(dream.schedulerRate ?? 0.0))
                                                .font(.callout)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.blue)
                                            Text(dream.scheduler )
                                                .font(.footnote)
                                        }
                                        .padding(.vertical, 10)
                                        .frame(width: geometry.size.width / 2 - 5)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        VStack {
                                            let targetDate = DreamDetailVewModel.calculateTargetDate(target: dream.target, scheduler: dream.scheduler , schedulerRate: dream.schedulerRate ?? 0.0, amount: dream.amount)
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
                        .background(Color(hex: dream.background))
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
            .toolbar(.hidden, for: .tabBar)
            .sheet(isPresented: $showModal) {
                AmountInputView(credit: $credit, operation: $operation, note: $note, uid: userData.uid, dreamId: dream.id, amount: dream.amount)
                    .presentationDetents([.large, .medium, .fraction(0.5)])
                
            }
        }
    }
}


#Preview {
    DetailDream(userData: UserData(uid: "123", email: "helo"), dream: Dreams.dummyData[0])
}
