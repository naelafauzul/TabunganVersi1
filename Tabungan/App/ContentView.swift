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
        TabView(selection: $selectedTab) {
            DreamList(DreamsVM: DreamsVM, userData: userData)
                .tag(0)
                .tabItem {
                    Label("Beranda", systemImage: "house")
                }
            
            UserView(userData: $userData)
                .tag(1)
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
        }
        .accentColor(.teal700)
        .onAppear {
            Task {
                self.userData = try await AuthAPIService.shared.getCurrentSession()
            }
        }
    }
}

#Preview {
    ContentView(userData: UserData(uid: "123", email: "hai@gmail.com"))
}
