//
//  ConfettiUIView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 03/06/24.
//

import SwiftUI
import UIKit

struct ConfettiUIView: UIViewRepresentable {
    var direction: ConfettiView.Direction
    var animation: ConfettiView.Animation
    
    func makeUIView(context: Context) -> ConfettiView {
        let confettiView = ConfettiView(
            emitters: [
                .shape(.rectangle, color: .systemRed),
                .shape(.rectangle, color: .systemPink),
                .shape(.rectangle, color: .systemYellow),
                .shape(.rectangle, color: .systemTeal),
                .shape(.rectangle, color: .systemBlue),
                .shape(.circle, color: .systemGreen),
                .shape(.circle, color: .systemRed),
                .shape(.circle, color: .systemPink),
                .shape(.circle, color: .systemYellow),
                .shape(.circle, color: .systemTeal),
                .shape(.circle, color: .systemBlue),
                .shape(.circle, color: .systemGreen)
            ],
            direction: direction,
            animation: animation
        )
        confettiView.isUserInteractionEnabled = false
        return confettiView
    }
    
    func updateUIView(_ uiView: ConfettiView, context: Context) {
        uiView.emit()
    }
}
