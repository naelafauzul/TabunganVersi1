//
//  DreamUsers.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 21/03/24.
//

import Foundation

struct DreamUsers: Codable {
    let id: String
    let dream_id: String
    let user_id: String?
    let profile: String
    let name: String
    let target: Double
    let amount: Double
    let is_active: Bool?
    let created: Int64
    let updated: Int64
}
