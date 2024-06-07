//
//  CreateDreamVM.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 21/03/24.
//

import Foundation
import SwiftUI

class CreateDreamVM: ObservableObject {
    @Published var emoticons: [Emoticon] = []
    
    
    func createDreams(uid: String, profile: String, background: String, name: String, name_user: String, target: Double, scheduler: String, schedulerRate: Double ) async throws {
        
        let timeNow = Int64(Date().timeIntervalSince1970 * 1000)
        let dreamId = UUID().uuidString.lowercased()
        let dreamUserId = UUID().uuidString.lowercased()
        let background = background
        
        print("Lowercased dreamId: \(dreamId)")
        print("Lowercased dreamUserId: \(dreamUserId)")
        
        let dream = Dreams(id: dreamId, userId: uid, code: dreamId, profile: profile, background: background, name: name, target: target, amount: 0.0, isActive: true, created: timeNow, updated: timeNow, scheduler: scheduler, schedulerRate: schedulerRate)
        
        let dreamUser = DreamUsers(id: dreamUserId, dreamId: dreamId, userId: uid, profile: "tabungan/emoticons/emoticon_19", name: name_user, target: target, amount: 0.0, isActive: true, created: timeNow, updated: timeNow)
        
        print("Creating dream: \(dream)")
        print("Creating dream user: \(dreamUser)")
        
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
    
    func loadEmoticons() {
        emoticons = EmoticonService.getEmoticons()
    }
    
    @MainActor
    func fetchUserName(for uid: String) async throws -> String {
        let user = try await DatabaseManager.shared.fetchUserFromDatabase(uid: uid)
        return user.name
    }
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}


