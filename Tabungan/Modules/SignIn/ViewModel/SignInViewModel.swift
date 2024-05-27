//
//  AuthViewModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import Foundation
import GoogleSignIn
import PostgREST

@MainActor
class SignInViewModel: ObservableObject {
    @Published var currentUser: UserData?
    
    let signInApple = SignInApple()
    let signInGoogle = SignInGoogle()
    
    func signInWithApple() async throws -> UserData {
        let appleResult = try await signInApple.startSigningWithAppleFlow()
        let userData = try await AuthAPIService.shared.SignInWithApple(idToken: appleResult.idToken, nonce: appleResult.nonce)
        
        // Periksa atau buat pengguna di database
        return try await handleUserData(userData)
    }
    
    func signInWithGoogle() async throws -> UserData {
        let googleResult = try await signInGoogle.startSignInWithGoogleFlow()
        let userData = try await AuthAPIService.shared.SignInWithGoogle(idToken: googleResult.idToken, nonce: googleResult.nonce)
        
        // Periksa atau buat pengguna di database
        return try await handleUserData(userData)
    }
    
    private func handleUserData(_ userData: UserData) async throws -> UserData {
        let userIdLowercased = userData.uid.lowercased()
        
        do {
            let existingUser = try await DatabaseManager.shared.fetchUserFromDatabase(uid: userIdLowercased)
            currentUser = convertUsersToUserData(users: existingUser)
            return convertUsersToUserData(users: existingUser)
        } catch {
            // User does not exist, create new user
            try await createUser(uid: userIdLowercased, email: userData.email, profile: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0)
            currentUser = userData
            return userData
        }
    }
    
    private func createUser(uid: String, email: String, profile: String, gender: String, day_of_birth: String, is_active: Bool, created: Int64, updated: Int64) async throws {
        let timeNow = Int64(Date().timeIntervalSince1970 * 1000)
        let profile = "celengan/emoticons/emoticon_19.svg"
        let gender = "Male"
        let day_of_birth = "01-01-2000"
        
        let nameParts = email.split(separator: "@")
        let name = String(nameParts.first ?? "")
        
        let user = Users(id: uid, email: email, profile: profile, name: name, gender: gender, day_of_birth: day_of_birth, is_active: true, created: timeNow, updated: timeNow)
        
        do {
            try await DatabaseManager.shared.createUserInDatabase(user)
        } catch {
            // Handle specific error code for duplicate key
            if let postgrestError = error as? PostgrestError, postgrestError.code == "23505" {
                print("User already exists.")
            } else {
                throw error
            }
        }
    }

    private func convertUsersToUserData(users: Users) -> UserData {
        return UserData(uid: users.id, email: users.email)
    }
}
