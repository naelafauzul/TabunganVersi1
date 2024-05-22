//
//  DreamsModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import Foundation

struct Dreams: Codable, Hashable {
    let id: String
    let userId: String?
    let code: String
    let profile: String
    let background: String
    let name: String
    let target: Double
    let amount: Double
    let isActive: Bool?
    let created: Int64
    let updated: Int64
    let scheduler: String
    let schedulerRate: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case code
        case profile
        case background
        case name
        case target
        case amount
        case isActive
        case created
        case updated
        case scheduler
        case schedulerRate 
    }
}

extension Dreams {
    static let dummyData = [
        Dreams(id: "1", userId: "1", code: "1", profile: "image1", background: "image1", name: "Rumah Impian 1", target: 100000, amount: 50000, isActive: true, created: 1679461923099, updated: 1679461923099, scheduler: "Month", schedulerRate: 5000)
       
    ]
}

