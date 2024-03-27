//
//  CreateDreamVM.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 21/03/24.
//

import Foundation
import SwiftUI

class CreateDreamVM: ObservableObject {
    
    func createDreams(uid: String, profile: String, background: String, name: String, name_user: String, target: Double, scheduler: String, schedulerRate: Double ) async throws {
        
        let timeNow = Int64(Date().timeIntervalSince1970 * 1000)
        let dreamId = UUID().uuidString
        let dreamUserId = UUID().uuidString
        let background = background
        
        let dream = Dreams(id: dreamId, userId: uid, code: dreamId, profile: profile, background: background, name: name, target: target, amount: 0.0, isActive: true, created: timeNow, updated: timeNow, scheduler: scheduler, schedulerRate: schedulerRate)
        
        let dreamUser = DreamUsers(id: dreamUserId, dream_id: dreamId, user_id: uid, profile: profile, name: name_user, target: target, amount: 0.0, is_active: true, created: timeNow, updated: timeNow)
        
        try await DatabaseManager.shared.createDreamItem(dream: dream, dreamUser: dreamUser)
    }
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    

    func calculateTargetDate(target: Double, scheduler: String, schedulerRate: Double) -> String {
        guard target > 0 && schedulerRate > 0 else {
            return ""
        }
        
        let timeNeeded = Int(ceil(target / schedulerRate))
        var timeUnit: String
        var component: Calendar.Component
        
        switch scheduler.lowercased() {
        case "days":
            timeUnit = "hari"
            component = .day
        case "weeks":
            timeUnit = "minggu"
            component = .weekOfYear
        case "month":
            timeUnit = "bulan"
            component = .month
        default:
            return ""
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        guard let targetDate = calendar.date(byAdding: component, value: Int(timeNeeded), to: currentDate) else {
            return "Tidak dapat menghitung tanggal target."
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "id_ID")
        let formattedTargetDate = dateFormatter.string(from: targetDate)
        
        return "Tercapai dalam \(timeNeeded) \(timeUnit) pada \(formattedTargetDate)"
    }
}


