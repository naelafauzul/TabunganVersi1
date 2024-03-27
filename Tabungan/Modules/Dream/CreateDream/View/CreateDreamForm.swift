//
//  CreateDreamForm.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct CreateDreamForm: View {
    
    @EnvironmentObject var CreateDreamVM: CreateDreamVM
    @Environment(\.dismiss) var dismiss
    @State var userData: UserData
    let user: Users
    
    @State private var selectedColor = "#ABD3DB"
    @State private var selectedEmoticon = ""
    
    @State private var name: String = ""
    @State private var target: Double? = 0
    @State private var scheduler_rate: Double? = 0
    @State private var scheduler: String = ""
    
    @State private var showingColorPicker = false
    @State private var showingEmoticon = false
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        VStack (alignment: .leading, spacing: 6){
                            Text("Sesuaikan Impianmu")
                                .font(.title3)
                            Text("Berikan nama, emoji, color, dan target.")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    
                    HStack {
                        Button {
                            showingEmoticon = true
                        } label: {
                            Image(systemName: "photo.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(.teal700)
                                .padding(2)
                        }
                        
                        Spacer()
                        
                        Image(systemName: selectedEmoticon)
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 100)
                            .background(Color(hex: selectedColor)).clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                        
                        Spacer()
                        
                        Button {
                            showingColorPicker = true
                        } label: {
                            Image(systemName: "eyedropper.full")
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(.teal700)
                                .clipShape(Circle())
                                .padding(2)
                        }
                    }
                    
                    CustomTextFieldString(text: $name, placeholder: "Nama Impian")
                        .padding(.vertical, 3)
                    
                    CustomTextFieldDouble(text: $target, placeholder: "Nominal Target", formatter: NumberFormatter())
                        .padding(.vertical, 3)
                    
                    CustomButton(scheduler: $scheduler)
                        .padding()
                    
                    CustomTextFieldDouble(text: $scheduler_rate, placeholder: "Nominal Pengisian", formatter: NumberFormatter())
                        .padding(.top, 3)
                    
                    
                    VStack {
                        let targetDate = CreateDreamVM.calculateTargetDate(target: target ?? 0, scheduler: scheduler, schedulerRate: scheduler_rate ?? 0)
                        Text(targetDate)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        
                        Button {
                            Task {
                                do {
                                    try await CreateDreamVM.createDreams(uid: userData.uid, profile: selectedEmoticon, background: selectedColor, name: name, name_user: user.name, target: target!, scheduler: scheduler, schedulerRate: scheduler_rate!)
                                    dismiss()
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text("Simpan")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity, minHeight: 42)
                                .background(.teal700)
                                .cornerRadius(10)
                        }
                        
                    }
                    .padding(.vertical, 2)
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 16)
            }
            .sheet(isPresented: $showingColorPicker) {
                CustomColorPicker(selectedColor: $selectedColor)
                    .presentationDetents([.large, .medium, .fraction(0.5)])
            }
            .sheet(isPresented: $showingEmoticon) {
                EmoticonView(selectedEmoticon: $selectedEmoticon)
                    .presentationDetents([.large, .medium, .fraction(0.5)])
            }
        }
    }
}

#Preview {
    CreateDreamForm(userData: .init(uid: "", email: ""), user: Users(id: "", email: "", profile: "", name: "", gender: "", day_of_birth: "", is_active: true, created: 0, updated: 0) )
        .environmentObject(CreateDreamVM())
}

