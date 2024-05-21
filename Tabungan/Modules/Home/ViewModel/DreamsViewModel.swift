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
    
    func updateDreamInViewModel(updatedDream: Dreams) {
            if let index = dreams.firstIndex(where: { $0.id == updatedDream.id }) {
                dreams[index] = updatedDream
                objectWillChange.send()
            }
        }
}
