//
//  Constant.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 15/03/24.
//

import Foundation
import Supabase

struct Constant {
    static let client = SupabaseClient(
        supabaseURL: URL(string: "https://atijrsvztjdenjmnsxzs.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0aWpyc3Z6dGpkZW5qbW5zeHpzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA0NzQ5NTcsImV4cCI6MjAyNjA1MDk1N30.tMGtNo5HFqbEiageTwaaK2iYzDrpMABCIPKClluPOL4")
}
