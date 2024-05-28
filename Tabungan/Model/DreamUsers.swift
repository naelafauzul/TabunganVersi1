//
//  DreamUsers.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 21/03/24.
//

import Foundation

struct DreamUsers: Codable, Identifiable {
    let id: String
    let dreamId: String
    let userId: String
    let profile: String
    let name: String
    let target: Double
    let amount: Double
    let isActive: Bool
    let created: Int64
    let updated: Int64
}
