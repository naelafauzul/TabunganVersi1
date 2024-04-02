//
//  BillHistory.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 21/03/24.
//

import Foundation

struct BillHistory: Codable {
    var id: String
    var userId: String
    var dreamId: String
    var userName: String
    var type: Int
    var amount: Double
    var current: Double
    var created: Int64
    var updated: Int64
}
