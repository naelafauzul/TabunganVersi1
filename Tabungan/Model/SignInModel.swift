//
//  SignInModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import Foundation
import Auth

struct SignInGoogleResult {
    let idToken: String
    let nonce: String
}

struct SignInAppleResult {
    let idToken: String
    let nonce: String
}

struct UserData {
    let uid: String
    let email: String
}


