import Foundation

class DreamDetailVM: ObservableObject {
    @Published var historyList = [BillHistory]()
    @Published var anggotaDreamUsers = [DreamUsers]()
    @Published var adminDreamUsers = [DreamUsers]()
    @Published var dreamUsers = [DreamUsers]()
    @Published var userAmount = [DreamUsers]()
    @Published var selectedEmoticonURL: URL? = nil
    
    @MainActor
    func fetchBillHistory(for dreamId: String) async throws {
        historyList = try await DatabaseManager.shared.fetchBillHistory(dreamId: dreamId)
    }
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    func formatDate(from timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.locale = Locale(identifier: "id_ID")
        return dateFormatter.string(from: date)
    }
    
    func formatDateWithYear(from timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "id_ID")
        return dateFormatter.string(from: date)
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
            return "Waktu tidak diketahui"
        }
        
        if timeNeeded < 0 {
            return "0 \(timeUnit) Lagi"
        }
        
        return "\(timeNeeded) \(timeUnit) Lagi"
    }
    
    @MainActor
    func fetchUserName(for uid: String) async throws -> String {
        let user = try await DatabaseManager.shared.fetchUserFromDatabase(uid: uid)
        return user.name
    }
    
    func addCredit(uid: String, dreamId: String, type: Int, amount: Double, credit: Double, note: String) async throws {
        let timeNow = Int64(Date().timeIntervalSince1970 * 1000)
        let billId = UUID().uuidString.lowercased()
        let newAmount = amount + credit
        let noteId = UUID().uuidString.lowercased()
        
        let userName = try await fetchUserName(for: uid)
        
        let billHistory = BillHistory(id: billId, userId: uid, dreamId: dreamId, userName: userName, type: type, amount: newAmount, current: credit, created: timeNow, updated: timeNow)
        
        let billHistoryNote = BillHistoryNote(id: noteId, billId: billId, userId: uid, note: note, createdAt: timeNow, updated: timeNow)
        
        try await DatabaseManager.shared.addCredit(dreamId: dreamId, userId: uid, billHistory: billHistory, amount: amount, credit: credit, billHistoryNote: billHistoryNote)
    }
    
    func subCredit(uid: String, dreamId: String, type: Int, amount: Double, credit: Double, note: String) async throws {
        let timeNow = Int64(Date().timeIntervalSince1970 * 1000)
        let billId = UUID().uuidString.lowercased()
        let newAmount = amount - credit
        let noteId = UUID().uuidString.lowercased()
        
        let userName = try await fetchUserName(for: uid)
        
        let billHistory = BillHistory(id: billId, userId: uid, dreamId: dreamId, userName: userName, type: type, amount: newAmount, current: credit, created: timeNow, updated: timeNow)
        
        let billHistoryNote = BillHistoryNote(id: noteId, billId: billId, userId: uid, note: note, createdAt: timeNow, updated: timeNow)
        
        try await DatabaseManager.shared.subCredit(dreamId: dreamId, userId: uid, billHistory: billHistory, amount: amount, credit: credit, billHistoryNote: billHistoryNote)
    }
    
    func deleteDream(dreamId: String, userId: String) async throws {
        try await DatabaseManager.shared.deleteDream(dreamId: dreamId, userId: userId)
    }
    
    func updateDream(dreamId: String, userId: String, profile: String, background: String, name: String, target: Double, scheduler: String, schedulerRate: Double) async throws {
        try await DatabaseManager.shared.updateDream(dreamId: dreamId, userId: userId, profile: profile, background: background, name: name, target: target, scheduler: scheduler, schedulerRate: schedulerRate)
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
    
    func updateEmoticonURL(for profile: String) async {
        selectedEmoticonURL = EmoticonService.getEmoticonURL(for: profile)
    }
    
    @MainActor
    func fetchAnggotaDreamUsers(for dreamId: String, excludeUserId: String) async throws {
        do {
            let userDreams = try await DatabaseManager.shared.fetchAnggotaDreamUsers(for: dreamId, excludeUserId: excludeUserId)
            DispatchQueue.main.async {
                self.anggotaDreamUsers = userDreams
            }
        } catch {
            print("Error fetching anggota dream: \(error)")
        }
    }
    
    @MainActor
    func fetchAdminDreamUsers(for dreamId: String, userId: String) async throws {
        do {
            let userDreams = try await DatabaseManager.shared.fetchAdminDreamUsers(for: dreamId, userId: userId)
            DispatchQueue.main.async {
                self.adminDreamUsers = userDreams
            }
        } catch {
            print("Error fetching admin dreams: \(error)")
        }
    }
    
    @MainActor
    func fetchDreamUsers(for dreamId: String) async throws {
        do {
            let dreamUsers = try await DatabaseManager.shared.fetchAllDreamUser(for: dreamId)
            DispatchQueue.main.async {
                self.dreamUsers = dreamUsers
            }
        } catch {
            print("Error fetching admin dreams: \(error)")
        }
    }
    
    func getUserAmount(dreamId: String, userId: String) async throws {
        do {
            let userAmount = try await DatabaseManager.shared.getUserAmount(userId: userId, dreamId: dreamId)
            DispatchQueue.main.async {
                self.userAmount = userAmount
            }
        } catch {
            print("Error fetching admin dreams: \(error)")
        }
    }
    
    func aturTarget(userId: String, dreamid: String, target: Double) async throws {
        do {
            let target = try await DatabaseManager.shared.aturTarget(userId: userId, dreamId: dreamid, target: target)

        } catch {
            print("Error updating target: \(error)")
        }
    }
}

