//
//  StorageManager.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 04/06/24.
//

import Foundation
import SupabaseStorage

class StorageManager {
    static let shared = StorageManager()
    
    private let supabaseUrl = "https://atijrsvztjdenjmnsxzs.supabase.co/storage/v1"
    
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0aWpyc3Z6dGpkZW5qbW5zeHpzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA0NzQ5NTcsImV4cCI6MjAyNjA1MDk1N30.tMGtNo5HFqbEiageTwaaK2iYzDrpMABCIPKClluPOL4"
    
    private let supabaseSecret = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0aWpyc3Z6dGpkZW5qbW5zeHpzIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcxMDQ3NDk1NywiZXhwIjoyMDI2MDUwOTU3fQ.tuhdRYSk4ZWR-4ROzNWQVL5XS2gwdxhW8Lp4Rf1mcTI"
    
    private let storage: SupabaseStorageClient
    
    private init() {
        self.storage = SupabaseStorageClient(url: supabaseUrl, headers: ["Authorization": "Bearer \(supabaseSecret)", "apiKey" : supabaseKey])
    }
    
    func uploadProfilePhoto(for userId: String, photoData: Data) async throws {
        let file = File(name: "\(userId).png", data: photoData, fileName: "\(userId).png", contentType: "image/png")
        
        do {
            try await storage.from(id: "tabungan").list(path: "\(userId)")
            let result = try await storage.from(id: "tabungan").update(path: "profile/\(userId).png", file: file, fileOptions: FileOptions(cacheControl: "3600"))
            print(result)
        } catch {
            let result = try await storage.from(id: "tabungan").upload(path: "profile/\(userId).png", file: file, fileOptions: FileOptions(cacheControl: "3600"))
            print(result)
        }
    }
    
    func fetchProfilePhoto(userId: String) async throws -> Data {
        return try await storage.from(id: "tabungan").download(path: "profile/\(userId).png")
    }
}


