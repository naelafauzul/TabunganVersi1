//
//  ProfileViewModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 26/03/24.
//

import Foundation
import UIKit

enum StateView {
    case idle
    case loading
    case joinSuccess
    case joinFailed(Error)
}

@MainActor
class ProfileVM: ObservableObject {
    @Published var user: Users?
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
        self.user = fetchedUser
    }
    
    func uploadProfilePhoto(for userId: String, photoData: Data) async throws {
        let uploadProfile = try await StorageManager.shared.uploadProfilePhoto(for: userId, photoData: photoData)
    }
    
    func updateUserInfo(userId: String, name: String, day_of_birth: String, gender: String) async throws {
        let userInfo: () = try await DatabaseManager.shared.updateUserInfo(userId: userId, name: name, day_of_birth: day_of_birth, gender: gender)
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
    
    func fetchProfilePhoto(for userId: String) async throws -> UIImage {
        let data = try await StorageManager.shared.fetchProfilePhoto(userId: userId)
        guard let image = UIImage(data: data) else {
            throw NSError()
        }
        return image
    }
}
