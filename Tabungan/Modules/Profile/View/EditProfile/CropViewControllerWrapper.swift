//
//  CropViewControllerWrapper.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 04/06/24.
//

import SwiftUI
import PhotosUI
import CropViewController


struct CropViewControllerWrapper: UIViewControllerRepresentable {
    var image: UIImage
    var onCrop: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> CropViewController {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = context.coordinator
        cropViewController.aspectRatioPreset = .presetSquare
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetAspectRatioEnabled = false
        cropViewController.toolbarPosition = .top
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        var parent: CropViewControllerWrapper
        
        init(_ parent: CropViewControllerWrapper) {
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.onCrop(image)
            cropViewController.dismiss(animated: true, completion: nil)
        }
        
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
}
