//
//  AuthViewModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import Foundation
import GoogleSignIn

@MainActor
class SignInViewModel: ObservableObject {
    
    let signInApple = SignInApple()
    let signInGoogle = SignInGoogle()
    
    func signInWithApple() async throws -> UserData {
        let appleResult = try await signInApple.startSigningWithAppleFlow()
        return try await AuthAPIService.shared.SignInWithApple(idToken: appleResult.idToken, nonce: appleResult.nonce)
    }
    
    func signInWithGoogle() async throws -> UserData {
        do {
            
            let googleResult = try await signInGoogle.startSignInWithGoogleFlow()
            let userData = try await AuthAPIService.shared.SignInWithGoogle(idToken: googleResult.idToken, nonce: googleResult.nonce)
            let existingUser = try? await DatabaseManager.shared.fetchUserFromDatabase(email: userData.email)
            
            if existingUser == nil {
                try await createUser(uid: userData.uid, email: userData.email, profile: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0)
            }
           
            return userData
        } catch {
            print("Error signing in with Google: \(error)")
            throw error 
        }
    }
    
    func createUser(uid: String, email: String, profile: String, gender: String, day_of_birth: String, is_active: Bool, created: Int64, updated: Int64) async throws {
        
        let timeNow = Int64(Date().timeIntervalSince1970 * 1000)
        let profile = "celengan/emoticons/emoticon_39.svg"
        let gender = "Male"
        let day_of_birth = "01-01-2000"
        
        // Extract the name from the email by splitting the string and taking the first part
        let nameParts = email.split(separator: "@")
        let name = String(nameParts.first ?? "") 
        
        let user = Users(id: uid, email: email, profile: profile, name: name, gender: gender, day_of_birth: day_of_birth, is_active: true, created: timeNow, updated: timeNow)
        
        try await DatabaseManager.shared.createUserInDatabase(user)
    }


}


