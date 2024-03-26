//
//  Users.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 21/03/24.
//

import Foundation

struct Users: Codable, Identifiable, Equatable {
    let id: String
    let email: String
    let profile: String
    let name: String
    let gender: String
    let day_of_birth: String
    let is_active: Bool
    let created: Int64
    let updated: Int64
}
