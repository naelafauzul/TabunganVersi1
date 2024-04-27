//
//  UserViewModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 26/03/24.
//

import Foundation

class UserVM: ObservableObject {
    @Published var user : Users?
    
    func createUser(uid: String, email: String, profile: String, name: String, gender: String, day_of_birth: String, isActive: Bool, created: Int64, updated: Int64) async throws {
        
        let timeNow = Int64(Date().timeIntervalSince1970 * 1000)
        let profile = "celengan/emoticons/emoticon_39.svg"
        let gender = "Male"
        let day_of_birth = "01-01-2000"
        
        let user = Users(id: uid, email: email, profile: profile, name: name, gender: gender, day_of_birth: day_of_birth, is_active: true, created: timeNow, updated: timeNow)
        
        try await DatabaseManager.shared.createUserInDatabase(user)
    }
    
    @MainActor
    func fetchUserInfo(for uid: String) async throws {
        user = try await DatabaseManager.shared.fetchUserFromDatabase(uid: uid)
    }
    
    
}
