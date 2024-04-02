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
    
    func fetchUserFromDatabase(email: String) async throws -> Users {
        let users: [Users] = try await client.database.from("users").select().equals("email", value: email).execute().value
        
        guard let user = users.first else {
            throw URLError(.badURL)
        }
        
        return user
    }
    
    func createDreamItem(dream: Dreams, dreamUser: DreamUsers) async throws {
        do {
            let response = try await client.database.from("dreams").insert(dream).execute()
            print(response)
            
            let response2 = try await client.database.from("dream_users").insert(dreamUser).execute()
            print(response2)
            
            print("Insert kedua data berhasil.")
            
        } catch {
            print("Terjadi kesalahan saat memasukkan data: \(error)")
            throw error
        }
    }

    func fetchDreamItem(for uid: String) async throws -> [Dreams] {
        let response = try await client.database.from("dreams").select().equals("userId", value: uid).order("created", ascending: true ).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dreams = try decoder.decode([Dreams].self, from: data)
        print(dreams)
        return dreams
    }
    
    func addCredit(dreamId: String, billHistory: BillHistory, amount: Double, credit: Double) async throws {
        do {
            _ = try await client.database.from("bill_history").insert(billHistory).execute()
            
            let newAmount = amount + credit
            _ = try await client.database.from("dreams").update(["amount": newAmount]).eq("id", value: dreamId).execute()
            
            let updateDreamUser = try await client.database.from("dream_users").update(["amount": newAmount]).eq("dream_id", value: dreamId).execute()
            
            print("Success")
        } catch {
            print("Error occurred while inserting data: \(error)")
            throw error
        }
    }
    
    func subCredit(dreamId: String, billHistory: BillHistory, amount: Double, credit: Double) async throws {
        do {
            _ = try await client.database.from("bill_history").insert(billHistory).execute()
            
            let newAmount = amount - credit
            _ = try await client.database.from("dreams").update(["amount": newAmount]).eq("id", value: dreamId).execute()
            
            let updateDreamUser = try await client.database.from("dream_users").update(["amount": newAmount]).eq("dream_id", value: dreamId).execute()
            
            print("Success")
        } catch {
            print("Error occurred while inserting data: \(error)")
            throw error
        }
    }

    
}
