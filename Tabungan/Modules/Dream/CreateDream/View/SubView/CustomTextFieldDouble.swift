//
//  CustomTextFieldDouble.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 20/03/24.
//
import SwiftUI

struct CustomTextFieldDouble: View {
    @Binding var text: Double?
    let placeholder: String
    var formatter: NumberFormatter
    
    @FocusState var focused: Bool
    
    private var textStringBinding: Binding<String> {
        Binding<String>(
            get: {
                if let value = self.text {
                    let formattedText = formatter.string(from: NSNumber(value: value)) ?? ""
                    return formattedText.isEmpty ? "" : formattedText
                } else {
                    return ""
                }
            },
            set: { newValue in
                guard let value = formatter.number(from: newValue)?.doubleValue else {
                    if newValue.isEmpty {
                        self.text = nil
                    }
                    return
                }
                if value >= 0 {
                    self.text = value
                }
            }
        )
    }
    
    var body: some View {
        let isActive = focused || (self.text != nil && self.text != 0)
        
        ZStack(alignment: isActive ? .topLeading : .center) {
            TextField("", text: textStringBinding)
                .frame(height: 24)
                .font(.system(size: 16, weight: .regular))
                .opacity(isActive ? 1 : 0)
                .offset(y: 7)
                .focused($focused)
            
            HStack {
                Text(placeholder)
                    .foregroundColor(.black.opacity(0.3))
                    .frame(height: 16)
                    .font(.system(size: isActive ? 12 : 16, weight: .regular))
                    .offset(y: isActive ? -7 : 0)
                Spacer()
            }
        }
        .onTapGesture {
            focused = true
        }
        .animation(.linear(duration: 0.2), value: focused)
        .frame(height: 56)
        .padding(.horizontal, 16)
        .background(.white)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(focused ? Color.teal700.opacity(0.6) : .black.opacity(0.2), lineWidth: 2)
        }
    }
}
