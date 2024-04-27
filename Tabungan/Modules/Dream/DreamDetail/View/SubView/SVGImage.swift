//
//  SVGImage.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 23/04/24.
//

import SwiftUI
import SVGKit

struct SVGImage: View {
    var url: URL
    @State private var svgImage: SVGKImage?
    @State private var isLoading = true

    var body: some View {
        VStack {
            if let image = svgImage {
                Image(uiImage: image.uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loadSVGImage()
        }
        .onChange(of: url) { newURL in
            loadSVGImage()
        }
    }

    private func loadSVGImage() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                if let loadedImage = SVGKImage(data: data) {
                    DispatchQueue.main.async {
                        self.svgImage = loadedImage
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        print("Error: Unable to create SVG image from data")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Error loading SVG data: \(error)")
                }
            }
        }
    }
}
