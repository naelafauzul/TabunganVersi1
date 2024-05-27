//
//  ContentView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//


import SwiftUI

struct ContentView: View {
    @State var userData: UserData? = nil
    @StateObject var DreamsVM = DreamsViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if userData != nil {
                TabView(selection: $selectedTab) {
                    DreamList(DreamsVM: DreamsVM, userData: $userData)
                        .tag(0)
                        .tabItem {
                            Label("Beranda", systemImage: "house")
                        }
                    
                    ProfileView(userData: $userData)
                        .tag(1)
                        .tabItem {
                            Label("Profil", systemImage: "person")
                        }
                }
                .accentColor(.teal700)
            } else {
                DreamList(DreamsVM: DreamsVM, userData: $userData)
            } 
        }
        .onAppear {
            Task {
                if let sessionUserData = try? await AuthAPIService.shared.getCurrentSession() {
                    userData = sessionUserData
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
