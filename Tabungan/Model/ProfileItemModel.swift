//
//  ProfileItemModel.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 23/05/24.
//


import Foundation

struct ProfileItemModel: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}
