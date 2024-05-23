//
//  DreamList.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct DreamList: View {
    @ObservedObject var DreamsVM: DreamsViewModel
    @StateObject var DreamDetailViewModel = DreamDetailVM()
    @Binding var userData: UserData?
    
    @State private var showingSignInView = false
    @State private var showingCreateForm = false
    @State var tabBarVisibility: Visibility = .visible
    @State private var selectedIndex = 0
    
    var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var filteredDreams: [Dreams] {
        if selectedIndex == 0 {
            return DreamsVM.dreams.filter { $0.amount < $0.target }
        } else {
            return DreamsVM.dreams.filter { $0.amount >= $0.target }
        }
    }
    
    var totalAmountSaved: Double {
        return DreamsVM.dreams.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        if let userData = userData {
                            
                            TotalView(totalAmount: Int(totalAmountSaved))
                            
                            HStack {
                                Text("Daftar Impian")
                                    .font(.callout)
                                Spacer()
                                SegmentedPickerView(titles: ["Berjalan", "Selesai"], selectedIndex: $selectedIndex)
                            }
                            .padding(.vertical, 10)
                            
                            LazyVGrid(columns: gridItemLayout) {
                                ForEach(filteredDreams, id: \.id) { dream in
                                    NavigationLink(destination: DetailDream(DreamsVM: DreamsVM, tabBarVisibility: $tabBarVisibility, userData: userData, dreamTemp: dream)
                                        .environmentObject(DreamDetailViewModel)
                                    ) {
                                        DreamItem(dream: dream)
                                    }
                                    .toolbar(.hidden, for: .tabBar)
                                }
                            }
                        } else {
                            NotLoggedView()
                        }
                    }
                    .onAppear {
                        if let userData = userData {
                            Task {
                                do {
                                    try await DreamsVM.fetchDreams(for: userData.uid)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                    .onChange(of: userData) { _ in
                        fetchDreamsIfNeeded()
                    }
                }
                .padding(.horizontal, 16)
                .toolbar(tabBarVisibility, for: .tabBar)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            guard userData != nil else {
                                showingSignInView = true
                                return
                            }
                            showingCreateForm = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title.weight(.semibold))
                                .padding()
                                .background(.teal700)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 4, x: 0, y: 4)
                            
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showingSignInView) {
                SignInView(userData: $userData)
                    .presentationDetents([.large, .medium, .fraction(0.25)])
            }
            .background(
                NavigationLink(
                    destination: CreateDreamForm(tabBarVisibility: $tabBarVisibility, userData: $userData, user: Users(id: "", email: "", profile: "", name: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0))
                        .environmentObject(DreamsVM), isActive: $showingCreateForm) {
                            EmptyView()
                        }
            )
        }
    }
    
    private func fetchDreamsIfNeeded() {
        guard let userData = userData, DreamsVM.dreams.isEmpty else { return }
        Task {
            do {
                try await DreamsVM.fetchDreams(for: userData.uid)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    DreamList(DreamsVM: DreamsViewModel(), userData: .constant(UserData(uid: "", email: "")))
}
