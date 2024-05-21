//
//  TabunganApp.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import SwiftUI
import GoogleSignIn

@main
struct TabunganApp: App {
    
    var createDreamVM = CreateDreamVM()
    var DreamDetailViewModel = DreamDetailVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView(userData: nil)
                .environmentObject(createDreamVM)
                .environmentObject(DreamDetailViewModel)
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance.handle(url)
                })
        }
    }
}


