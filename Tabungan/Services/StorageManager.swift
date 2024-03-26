//
//  StorageManager.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 26/03/24.
//

import Foundation
import Supabase
import SupabaseStorage

class StorageManager {
    static let shared = StorageManager()
    
    let client = Constant.client
    
    func fetchDreamItem(for uid: String) async throws -> [Dreams] {
        let response = try await client.database.from("dreams").select().equals("user_id", value: uid).order("created", ascending: true ).execute()
        let data = response.data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dreams = try decoder.decode([Dreams].self, from: data)
        print(dreams)
        return dreams
    }
    
    
    
//    func fetchEmoticon() async throws -> [Emoticon] {
//        let response = try await client.storage.from("emoticon")
//            .list(
//                path: "public/celengan" )
//        
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        let emoticons = try decoder.decode([Emoticon], from: data)
//    }
}
