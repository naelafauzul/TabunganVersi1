//
//  DreamsViewModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import Foundation
import SwiftUI

class DreamsViewModel: ObservableObject {
    @Published var dreams = [Dreams]()
    @Published var totalAmount: Double = 0
    
    @MainActor
    func fetchDream(for uid: String) async throws {
        dreams = try await DatabaseManager.shared.fetchDreamItem(for: uid)
    }
    
    
    func deleteItems() async throws {
        
    }
    
    
    func fetchTotalAmount(for uid: String) async throws {
        totalAmount = try await DatabaseManager.shared.fetchTotalAmount(for: uid)
    }
    
}
