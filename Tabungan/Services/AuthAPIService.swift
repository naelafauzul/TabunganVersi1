//
//  AuthAPIService.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import Foundation
import Supabase

class AuthAPIService {
    static let shared = AuthAPIService()
    
    let client = Constant.client
    
    func SignInWithApple(idToken: String, nonce: String) async throws -> UserData {
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
        print(session)
        print(session.user)
        return UserData(uid: session.user.id.uuidString, email: session.user.email ?? "not login yet")
    }
    
    func getCurrentSession() async throws -> UserData {
        let session =  try await client.auth.session
        print(session)
        return UserData(uid: session.user.id.uuidString, email: session.user.email ?? "not login yet")
    }
    
    func SignInWithGoogle(idToken: String, nonce: String) async throws -> UserData {
        let session = try await client.auth.signInWithIdToken(credentials: .init(provider: .google, idToken: idToken, nonce: nonce))
        print(session)
        print(session.user)
        return UserData(uid: session.user.id.uuidString, email: session.user.email ?? "not login yet")
    }
    
    func getCurrentUserID() async throws -> String {
        let session = try await client.auth.session
        return session.user.id.uuidString
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
        print("Signed out successfully")
        
    }
}
