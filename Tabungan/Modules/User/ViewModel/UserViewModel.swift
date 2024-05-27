//
//  UserViewModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 26/03/24.
//

import Foundation

enum StateView {
    case idle
    case loading
    case joinSuccess
    case joinFailed(Error)
}


@MainActor
class UserVM: ObservableObject {
    @Published var user : Users?
    @Published var state: StateView = .idle
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String?
    
    func createUser(uid: String, email: String, profile: String, name: String, gender: String, day_of_birth: String, isActive: Bool, created: Int64, updated: Int64) async throws {
        
        let timeNow = Int64(Date().timeIntervalSince1970 * 1000)
        let profile = "celengan/emoticons/emoticon_39.svg"
        let gender = "Male"
        let day_of_birth = "01-01-2000"
        
        let user = Users(id: uid, email: email, profile: profile, name: name, gender: gender, day_of_birth: day_of_birth, is_active: true, created: timeNow, updated: timeNow)
        
        try await DatabaseManager.shared.createUserInDatabase(user)
    }
    
    func fetchUserInfo(for uid: String) async throws {
        let fetchedUser = try await DatabaseManager.shared.fetchUserFromDatabase(uid: uid)
        DispatchQueue.main.async {
            self.user = fetchedUser
        }
    }
    
    @MainActor
    func joinDream(code: String, userId: String, profile: String, name: String) {
        Task {
            do {
                state = .loading
                try await DatabaseManager.shared.joinDream(code: code, userId: userId, profile: profile, name: name)
                state = .joinSuccess
                showErrorAlert = false
            } catch {
                state = .joinFailed(error)
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
    
    func resetError() {
        errorMessage = nil
        showErrorAlert = false
    }
    
    func signOut() async throws {
        try await AuthAPIService.shared.signOut()
        self.user = nil
    }
}
