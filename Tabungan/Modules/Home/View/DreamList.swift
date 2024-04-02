//
//  DreamList.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct DreamList: View {
    @StateObject var DreamsVM = DreamsViewModel()
    var userData: UserData?
    
    @State private var showingSignInView = false
    @State private var showingCreateForm = false
    
    var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    TotalView()
                    LazyVGrid(columns: gridItemLayout) {
                        ForEach(DreamsVM.dreams, id: \.id) { dream in
                            NavigationLink(destination: DetailDream(userData: userData!, dream: dream)
                            ) {
                                DreamItem(dream: dream)
                            }
                        }
                    }
                }
                .onAppear {
                    if let userData = userData {
                        Task {
                            do {
                                try await DreamsVM.fetchDream(for: userData.uid)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .toolbar(.visible, for: .tabBar)
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
            .sheet(isPresented: $showingSignInView) {
                SignInView(userData: userData)
                    .presentationDetents([.large, .medium, .fraction(0.25)])
            }
            .background(
                NavigationLink(
                    destination: CreateDreamForm(userData: userData ?? UserData(uid: "", email: ""), user: Users(id: "", email: "", profile: "", name: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0))
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
