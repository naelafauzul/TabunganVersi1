//
//  DreamDetailVM.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 27/03/24.
//

import Foundation

class DreamDetailVM: ObservableObject {
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    func calculateTargetDate(target: Double, scheduler: String, schedulerRate: Double, amount: Double) -> String {
        let currentTarget = target - amount
        let timeNeeded = Int(ceil(currentTarget / schedulerRate))
        var timeUnit: String
        
        
        switch scheduler.lowercased() {
        case "days":
            timeUnit = "Hari"
        case "weeks":
            timeUnit = "Minggu"
        case "month":
            timeUnit = "Bulan"
          
        default:
            return ""
        }
        
        
        return "\(timeNeeded) \(timeUnit) Lagi"
    }
}
