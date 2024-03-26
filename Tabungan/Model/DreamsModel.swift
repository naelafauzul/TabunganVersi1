//
//  DreamsModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import Foundation

struct Dreams: Codable {
    let id: String
    let user_id: String?
    let code: String
    let profile: String
    let background: String
    let name: String
    let target: Double
    let amount: Double
    let scheduler: String?
    let scheduler_rate: Double?
    let is_active: Bool?
    let created: Int64
    let updated: Int64
}


extension Dreams {
    static let dummyData = [
        Dreams(id: "1", user_id: "1", code: "1", profile: "image1", background: "image1", name: "Rumah Impian 1", target: 100000, amount: 50000, scheduler: "Month", scheduler_rate: 5000, is_active: true, created: 1679461923099, updated: 1679461923099),
        Dreams(id: "2", user_id: "2", code: "2", profile: "image2", background: "image2", name: "Rumah Impian 2", target: 150000, amount: 75000, scheduler: "Month", scheduler_rate: 5000, is_active: true, created: 1679461923099, updated: 1679461923099),
        Dreams(id: "3", user_id: "3", code: "3", profile: "image3", background: "image3", name: "Rumah Impian 3", target: 200000, amount: 100000, scheduler: "Month", scheduler_rate: 5000, is_active: true, created: 1679461923099, updated: 1679461923099)
    ]
}
