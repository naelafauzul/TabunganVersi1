//
//  DreamList.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct DreamList: View {
    @StateObject var DreamsVM = DreamsViewModel()
    @StateObject var DreamDetailVewModel = DreamDetailVM()
    var userData: UserData?
    
    @State private var showingSignInView = false
    @State private var showingCreateForm = false
    @State var tabBarVisibility: Visibility = .visible
    
    var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    TotalView()
                    LazyVGrid(columns: gridItemLayout) {
                        ForEach(DreamsVM.dreams, id: \.id) { dream in
                            NavigationLink(destination: DetailDream(tabBarVisibility: $tabBarVisibility, userData: userData!, dream: dream)
                                .environmentObject(DreamDetailVewModel)
                            ) {
                                DreamItem(dream: dream)
                            }
                            .toolbar(.hidden, for: .tabBar)
                        }
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
            }
            .padding(.horizontal, 16)
            .toolbar {
                Button(action: {
                    guard userData != nil else {
                        showingSignInView = true
                        return
                    }
                    showingCreateForm = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.teal700)
                        .padding(2)
                }
            }
            .toolbar(tabBarVisibility, for: .tabBar)
            .sheet(isPresented: $showingSignInView) {
                SignInView(userData: userData)
                    .presentationDetents([.large, .medium, .fraction(0.25)])
            }
            .background(
                NavigationLink(
                    destination: CreateDreamForm(tabBarVisibility: $tabBarVisibility, userData: userData ?? UserData(uid: "", email: ""), user: Users(id: "", email: "", profile: "", name: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0))
                    .environmentObject(DreamsVM), isActive: $showingCreateForm) {
                        EmptyView()
                    }
            )
        }
    }
}


#Preview {
    DreamList(userData: .init(uid: "", email: ""))
}

