//
//  BillHistoryWithNote.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 04/04/24.
//

import Foundation

struct BillHistoryWithNote: Identifiable, Codable {
    var id: String
    var userId: String
    var dreamId: String
    var userName: String
    var type: Int
    var amount: Double
    var current: Double
    var created: Int64
    var updated: Int64
    var note: String?
}
