//
//  BillHistoryNote.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 21/03/24.
//

import Foundation

struct BillHistoryNote: Codable {
    let id: String
    let billId: String
    let userId: String
    let note: String
    let createdAt: Int64
    let updated: Int64
    
    enum CodingKeys: String, CodingKey {
        case id
        case billId = "bill_id"
        case userId = "user_id"
        case note
        case createdAt = "created_at"
        case updated
    }
}
