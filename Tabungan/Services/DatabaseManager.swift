//
//  DatabaseManager.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import Foundation
import Supabase
import SupabaseStorage

class DatabaseManager {
    static let shared = DatabaseManager()
    
    let client = Constant.client
    
    func createUserInDatabase(_ user: Users) async throws {
        try await client.database.from("users").insert(user).execute()
    }
    
    func fetchUserFromDatabase(uid: String) async throws -> Users {
        let users: [Users] = try await client.database.from("users").select().equals("id", value: uid).execute().value
        
        guard let user = users.first else {
            throw URLError(.badURL)
        }
        
        return user
    }
    
    func fetchUserInfo(for uid: String) async throws -> Users {
        let response = try await client.database.from("dreams").select().equals("id", value: uid).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dreams = try decoder.decode(Users.self, from: data)
        print(dreams)
        return dreams
    }
    
    func createDreamItem(dream: Dreams, dreamUser: DreamUsers) async throws {
        do {
            let _ = try await client.database.from("dreams").insert(dream).execute()
            let _ = try await client.database.from("dream_users").insert(dreamUser).execute()
            
            print("Successfully created dream and dream user")
        } catch {
            print("Error occurred while creating dream and dream user: \(error)")
            throw error
        }
    }
    
    
    func fetchUserDreams(for uid: String) async throws -> [DreamUsers] {
        let response = try await client.database.from("dream_users").select()
            .eq("userId", value: uid)
            .eq("isActive", value: true)
            .order("created", ascending: true)
            .execute()
        
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dreamUsers = try decoder.decode([DreamUsers].self, from: data)
        return dreamUsers
    }
    
    func fetchDreamsByIds(dreamsIds: [String]) async throws -> [Dreams] {
        let response = try await client.database.from("dreams").select()
            .in("id", value: dreamsIds)
            .eq("isActive", value: true)
            .order("created", ascending: true)
            .execute()
        
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dreams = try decoder.decode([Dreams].self, from: data)
        return dreams
    }
    
    
    func addCredit(dreamId: String, userId: String, billHistory: BillHistory, amount: Double, credit: Double, billHistoryNote: BillHistoryNote) async throws {
        do {
            _ = try await client.database.from("bill_history").insert(billHistory).execute()
            
            _ = try await client.database.from("bill_history_note").insert(billHistoryNote).execute()
            
            let newAmount = amount + credit
            _ = try await client.database.from("dreams").update(["amount": newAmount]).eq("id", value: dreamId).execute()
            
            _ = try await client.database.from("dream_users").update(["amount": newAmount]).eq("dreamId", value: dreamId).eq("userId", value: userId).execute()
            
            print("Success")
        } catch {
            print("Error occurred while inserting data: \(error)")
            throw error
        }
    }
    
    func subCredit(dreamId: String, userId: String, billHistory: BillHistory, amount: Double, credit: Double, billHistoryNote: BillHistoryNote) async throws {
        do {
            _ = try await client.database.from("bill_history").insert(billHistory).execute()
            
            _ = try await client.database.from("bill_history_note").insert(billHistoryNote).execute()
            
            let newAmount = amount - credit
            _ = try await client.database.from("dreams").update(["amount": newAmount]).eq("id", value: dreamId).execute()
            
            _ = try await client.database.from("dream_users").update(["amount": newAmount]).eq("dreamId", value: dreamId).eq("userId", value: userId).execute()
            
            print("Success")
        } catch {
            print("Error occurred while inserting data: \(error)")
            throw error
        }
    }
    
    func fetchNotes(forBillId billId: String) async throws -> [BillHistoryNote] {
        let response = try await client.database.from("bill_history_note").select("*").eq("billId", value: billId).execute()
        
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let notes = try decoder.decode([BillHistoryNote].self, from: data)
        
        return notes
    }
    
    func fetchBillHistory(dreamId: String) async throws -> [BillHistory] {
        let response = try await client.database.from("bill_history")
            .select()
            .eq("dreamId", value: dreamId)
            .order("created", ascending: false)
            .execute()
        
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        var billHistories = try decoder.decode([BillHistory].self, from: data)
        
        // fetch notes for each billHistory and associate them
        try await withThrowingTaskGroup(of: (Int, [BillHistoryNote]).self, body: { group in
            for (index, billHistory) in billHistories.enumerated() {
                group.addTask {
                    let notes = try await self.fetchNotes(forBillId: billHistory.id)
                    return (index, notes)
                }
            }
            
            for try await (index, notes) in group {
                billHistories[index].notes = notes
            }
        })
        
        return billHistories
    }
    
    func deleteDream(dreamId: String, userId: String) async throws {
        do {
            _ = try await client.database.from("dreams")
                .update(["isActive": false])
                .equals("id", value: dreamId)
                .equals("userId", value: userId)
                .execute()
            
            _ = try await client.database.from("dream_users")
                .update(["isActive": false])
                .equals("dreamId", value: dreamId)
                .equals("userId", value: userId)
                .execute()
            
            print("Success deactivated dream \(dreamId)")
        } catch {
            print("Error occurred while deactivate dream: \(error)")
            throw error
        }
    }
    
    func updateDream(dreamId: String, userId: String, profile: String, background: String, name: String, target: Double, scheduler: String, schedulerRate: Double) async throws {
        do {
            let _ = try await client.database
                .from("dreams")
                .update([
                    "profile": profile,
                    "background": background,
                    "name": name,
                    "target": String(target),
                    "scheduler": scheduler,
                    "schedulerRate": String(schedulerRate)
                ])
                .eq("id", value: dreamId)
                .execute()
            
            print("Success updated dream \(dreamId)")
        } catch {
            print("Error occurred while updating dream: \(error)")
            throw error
        }
    }
    
    func updateUserInfo(userId: String, name: String, day_of_birth: String, gender: String) async throws {
        do {
            let _ = try await client.database
                .from("users")
                .update(["name" : name,
                         "day_of_birth" : day_of_birth,
                         "gender" : gender
                        ]).eq("id", value: userId).execute()
            
            let _ = try await client.database.from("dream_users").update(["name" : name]).eq("userId", value: userId).execute()
            let _ = try await client.database.from("bill_history").update(["userName" : name]).eq("userId", value: userId).execute()
            
            print("Success updated dream \(userId)")
        } catch {
            print("Error occurred while updating dream: \(error)")
            throw error
        }
    }
    
    func joinDream(code: String, userId: String, profile: String, name: String) async throws {
        
        let response = try await client.database.from("dreams").select().eq("code", value: code).execute()
        let data = response.data
        
        guard let dreams = try? JSONDecoder().decode([Dreams].self, from: data), let dream = dreams.first else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Kode undangan tidak valid."])
        }
        
        guard dream.userId != userId else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Ini adalah impianmu."])
        }
        
        guard dream.isActive ?? true else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Impian sudah tidak aktif."])
        }
        
        let userDreamResponse = try await client.database.from("dream_users").select().eq("userId", value: userId).eq("dreamId", value: dream.id).execute()
        let dataUser = userDreamResponse.data
        
        guard let userDreams = try? JSONDecoder().decode([DreamUsers].self, from: dataUser) else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Kode undangan tidak valid."])
        }
        
        _ = try? JSONDecoder().decode(DreamUsers.self, from: dataUser)
        
        if let currentUserDream = userDreams.first {
            guard !currentUserDream.isActive else {
                throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Kamu telah bergabung di impian ini."])
            }
            
            try await client.database.from("dream_users").update(["isActive": true]).eq("id", value: currentUserDream.id).execute()
        } else {
            let timeNow = Date().timeIntervalSince1970
            let newUserDream = DreamUsers(
                id: UUID().uuidString,
                dreamId: dream.id,
                userId: userId,
                profile: profile,
                name: name,
                target: 0.0,
                amount: 0.0,
                isActive: true,
                created: Int64(timeNow),
                updated: Int64(timeNow)
            )
            try await client.database.from("dream_users").insert(newUserDream).execute()
            print("berhasil insert new user : \(newUserDream)")
        }
    }
    
    func fetchAnggotaDreamUsers(for dreamId: String, excludeUserId: String) async throws -> [DreamUsers] {
        let response = try await client.database.from("dream_users").select()
            .eq("dreamId", value: dreamId)
            .neq("userId", value: excludeUserId)
            .execute()
        
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dreamUsers = try decoder.decode([DreamUsers].self, from: data)
        return dreamUsers
    }
    
    func fetchAdminDreamUsers(for dreamId: String, userId: String) async throws -> [DreamUsers] {
        let response = try await client.database.from("dream_users").select()
            .eq("dreamId", value: dreamId)
            .eq("userId", value: userId)
            .execute()
        
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dreamUsers = try decoder.decode([DreamUsers].self, from: data)
        return dreamUsers
    }
    
    func fetchAllDreamUser(for dreamId: String) async throws -> [DreamUsers] {
        let response = try await client.database.from("dream_users").select()
            .eq("dreamId", value: dreamId)
            .execute()
        
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dreamUsers = try decoder.decode([DreamUsers].self, from: data)
        return dreamUsers
    }
    
    func getUserAmount(userId: String, dreamId: String) async throws -> [DreamUsers] {
        let response = try await client.database.from("dream_users").select()
            .eq("userId", value: userId)
            .eq("dreamId", value: dreamId)
            .execute()
        
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dreamUsers = try decoder.decode([DreamUsers].self, from: data)
        return dreamUsers
    }
    
    func updateProfileDreamUser(userId: String, profile: String) async throws {
        do {
            let _ = try await client.database
                .from("dream_users")
                .update(["profile": profile]).eq("userId", value: userId).execute()
            
            print("Success profile dream user \(userId)")
        } catch {
            print("Error occurred while updating dream: \(error)")
            throw error
        }
    }
    
    func aturTarget(userId: String, dreamId: String, target: Double) async throws {
        do {
            let _ = try await client.database
                .from("dream_users")
                .update(["target" : target]).eq("userId", value: userId).eq("dreamId", value: dreamId).execute()
            
            print("Success atur target \(dreamId)")
        } catch {
            print("Error occurred while atur target: \(error)")
            throw error
        }
    }
}

