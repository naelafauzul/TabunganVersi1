//
//  CreateDreamForm.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 18/03/24.
//

import SwiftUI

struct CreateDreamForm: View {
    @EnvironmentObject var CreateDreamVM: CreateDreamVM
    @EnvironmentObject var DreamDetailViewModel: DreamDetailVM
    @Environment(\.dismiss) var dismiss
    
    @Binding var tabBarVisibility: Visibility
    @Binding var userData: UserData?
    var user: Users
    
    @State private var selectedColor = "#ABD3DB"
    @State private var selectedEmoticon = ""
    @State private var selectedEmoticonURL: URL? = nil
    
    @State private var name: String = ""
    @State private var target: Double? = nil
    @State private var scheduler_rate: Double? = nil
    @State private var scheduler: String = ""
    
    @State private var showingColorPicker = false
    @State private var showingEmoticon = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var username: String? = nil
    
    var body: some View {
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
                    
                    if selectedEmoticonURL != nil {
                        EmoticonItem(url: $selectedEmoticonURL)
                            .frame(width: 100, height: 100)
                            .background(Color(hex: selectedColor))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                        
                    } else {
                        Image(systemName: "photo")
                            .frame(width: 100, height: 100)
                            .background(Color(hex: selectedColor))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                    }
                    
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
                        if name.isEmpty || target == nil || scheduler_rate == nil || scheduler.isEmpty || selectedEmoticon.isEmpty {
                            alertMessage = "Semua kolom dan gambar harus diisi!"
                            showingAlert = true
                        } else if target == nil || scheduler_rate == nil {
                            alertMessage = "Nominal Target dan Nominal Pengisian harus berupa angka!"
                            showingAlert = true
                        } else {
                            Task {
                                do {
                                    try await CreateDreamVM.createDreams(uid: userData?.uid ?? "", profile: selectedEmoticon, background: selectedColor, name: name, name_user: username ?? "", target: target!, scheduler: scheduler, schedulerRate: scheduler_rate!)
                                    dismiss()
                                } catch {
                                    print(error)
                                }
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
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Peringatan"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                }
                .padding(.vertical, 2)
                Spacer()
                
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            tabBarVisibility = .hidden
            Task {
                do {
                    username = try await DreamDetailViewModel.fetchUserName(for: userData!.uid)
                } catch {
                    print("Failed to fetch username: \(error)")
                }
            }
        }
        .onDisappear {
            tabBarVisibility = .visible
        }
        .sheet(isPresented: $showingColorPicker) {
            CustomColorPicker(selectedColor: $selectedColor)
                .presentationDetents([.large, .medium, .fraction(0.5)])
        }
        .sheet(isPresented: $showingEmoticon) {
            EmoticonView(selectedEmoticon: $selectedEmoticon, selectedEmoticonURL: $selectedEmoticonURL)
                .presentationDetents([.large, .medium, .fraction(0.5)])
        }
    }
}


#Preview {
    CreateDreamForm(
        tabBarVisibility: .constant(.visible),
        userData: .constant(UserData(uid: "123", email: "example@example.com")),
        user: Users(id: "1", email: "user@example.com", profile: "profile1", name: "User", gender: "M", day_of_birth: "1990-01-01", is_active: true, created: 1234567890, updated: 1234567890)
    )
}
