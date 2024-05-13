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
    
    @MainActor
    func fetchDreams(for uid: String) async throws {
        dreams = try await DatabaseManager.shared.fetchDreamItem(for: uid)
    }
    
}
