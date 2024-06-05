//
//  EditProfileView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 04/06/24.
//

import SwiftUI
import PhotosUI
import CropViewController

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var profileViewModel = ProfileVM()
    @Binding var userData: UserData?
    
    @State private var showPhotoSheet = false
    @State private var showPhotoLibrary = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State var profileImage = Image(systemName: "person")
    @State private var isUploading = false
    @State private var uploadProgress: Double = 0.0
    @State private var showCropView = false
    @State private var imageToCrop: UIImage?
    
    @State private var name: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedGender: Gender = .pria
    
    enum Gender: String, CaseIterable, Identifiable {
        case pria, wanita
        
        var id: Self { self }
        
        var databaseValue: String {
            switch self {
            case .pria:
                return "Male"
            case .wanita:
                return "Female"
            }
        }
        
        init(databaseValue: String) {
            switch databaseValue {
            case "Male":
                self = .pria
            case "Female":
                self = .wanita
            default:
                self = .pria
            }
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .onTapGesture {
                        showPhotoSheet.toggle()
                    }
                    .confirmationDialog("Pilih profil foto", isPresented: $showPhotoSheet) {
                        Button {
                            showPhotoLibrary.toggle()
                        } label: {
                            Text("Photo Library")
                        }
                    }
                    .photosPicker(isPresented: $showPhotoLibrary, selection: $selectedPhoto, photoLibrary: .shared())
                    .onChange(of: selectedPhoto) { newValue in
                        guard let photoItem = selectedPhoto else {
                            return
                        }
                        
                        Task {
                            if let photoData = try await photoItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: photoData) {
                                imageToCrop = uiImage
                                showCropView = true
                            }
                        }
                    }
                
                if isUploading {
                    ProgressView(value: uploadProgress, total: 1.0)
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 80, height: 80)
                }
            }
            .padding(.top, 50)
            
            CustomTextFieldString(text: $name, placeholder: "Nama Impian")
                .padding(.top, 20)
            
            DatePicker("Tanggal Lahir",
                       selection: $selectedDate,
                       displayedComponents: .date)
            .frame(height: 56)
            .padding(.horizontal, 16)
            .background(.white)
            .cornerRadius(12)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.black.opacity(0.2), lineWidth: 2)
            }
            .padding(.top, 10)
            
            HStack {
                Text("Jenis Kelamin")
                Spacer()
                Picker("Gender", selection: $selectedGender) {
                    Text("Pria").tag(Gender.pria)
                    Text("Wanita").tag(Gender.wanita)
                }
                .foregroundStyle(.black)
            }
            .frame(height: 56)
            .padding(.horizontal, 16)
            .background(.white)
            .cornerRadius(12)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.black.opacity(0.2), lineWidth: 2)
            }
            .padding(.top, 10)
            
            Button {
                Task {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let dateOfBirthString = dateFormatter.string(from: selectedDate)
                    
                    do {
                        try await profileViewModel.updateUserInfo(userId: userData?.uid ?? "", name: name, day_of_birth: dateOfBirthString, gender: selectedGender.databaseValue)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Error updating user info: \(error)")
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Simpan")
                        .foregroundStyle(.white)
                    Spacer()
                }
            }
            .padding()
            .background(Color.teal700)
            .cornerRadius(8)
            .padding(.top, 30)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle("Ubah profil")
        .onAppear {
            Task {
                do {
                    if let uid = userData?.uid {
                        let uiImage = try await profileViewModel.fetchProfilePhoto(for: uid)
                        profileImage = Image(uiImage: uiImage)
                        try await profileViewModel.fetchUserInfo(for: uid)
                        if let userInfo = profileViewModel.user {
                            name = userInfo.name
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            if let dateOfBirth = dateFormatter.date(from: userInfo.day_of_birth) {
                                selectedDate = dateOfBirth
                            }
                            
                            selectedGender = Gender(databaseValue: userInfo.gender)
                        }
                    }
                } catch {
                    print("Error fetching user data: \(error)")
                }
            }
        }
        .sheet(isPresented: $showCropView) {
            if let imageToCrop = imageToCrop {
                CropViewControllerWrapper(image: imageToCrop) { croppedImage in
                    Task {
                        isUploading = true
                        uploadProgress = 0.0
                        
                        if let croppedImageData = croppedImage.jpegData(compressionQuality: 0.8) {
                            do {
                                try await profileViewModel.uploadProfilePhoto(for: userData?.uid ?? "", photoData: croppedImageData)
                            } catch {
                                print(error)
                            }
                            
                            profileImage = Image(uiImage: croppedImage)
                            isUploading = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EditProfileView(userData: .constant(UserData(uid: "123", email: "naela@gmail.com")))
}
