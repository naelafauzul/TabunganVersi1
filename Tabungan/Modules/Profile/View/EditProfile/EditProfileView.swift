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
    
    var body: some View {
        VStack {
            ZStack {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
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
            .onAppear {
                Task {
                    do {
                        let uiImage = try await profileViewModel.fetchProfilePhoto(for: userData?.uid ?? "")
                        profileImage = Image(uiImage: uiImage)
                    }
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
                            
                            await MainActor.run {
                                profileImage = Image(uiImage: croppedImage)
                                isUploading = false
                            }
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
