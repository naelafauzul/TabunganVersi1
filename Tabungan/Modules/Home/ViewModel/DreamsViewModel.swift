//
//  DreamsViewModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import Foundation
import SwiftUI

enum StateView {
    case idle
    case loading
    case joinSuccess
    case joinFailed(Error)
}

class DreamsViewModel: ObservableObject {
    @Published var dreams = [Dreams]()
    @Published var state: StateView = .idle

    
    @MainActor
    func fetchDreams(for uid: String) async throws {
        do {
            let userDreams = try await DatabaseManager.shared.fetchUserDreams(for: uid)
            let dreamsIds = userDreams.map { $0.dreamId }
            let dreams = try await DatabaseManager.shared.fetchDreamsByIds(dreamsIds: dreamsIds)
            DispatchQueue.main.async {
                self.dreams = dreams
            }
        } catch {
            print("Error fetching dreams: \(error)")
        }
    }
    
    
    func updateDreamInViewModel(updatedDream: Dreams) {
        if let index = dreams.firstIndex(where: { $0.id == updatedDream.id }) {
            dreams[index] = updatedDream
            objectWillChange.send()
        }
    }
    
    func joinDream(code: String, userId: String, profile: String, name: String) {
            Task {
                do {
                    state = .loading
                    try await DatabaseManager.shared.joinDream(code: code, userId: userId, profile: profile, name: name)
                    state = .joinSuccess
                } catch {
                    state = .joinFailed(error)
                }
            }
        }
}
