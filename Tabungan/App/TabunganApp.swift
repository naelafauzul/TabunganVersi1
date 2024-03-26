//
//  TabunganApp.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import SwiftUI
import GoogleSignIn
import SDWebImageSVGCoder

@main
struct TabunganApp: App {
    
    var createDreamVM = CreateDreamVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView(userData: nil)
                .environmentObject(createDreamVM)
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance.handle(url)
                })
        }
    }
}

private extension TabunganApp {
    
    func setUpDependencies() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}
