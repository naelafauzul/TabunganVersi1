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
}
