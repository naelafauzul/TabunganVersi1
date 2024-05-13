//
//  EmoticonView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 22/03/24.
//

import SwiftUI
import SVGKit

struct EmoticonView: View {
    private let emoticons = EmoticonService.getEmoticons()
    private let columns = [GridItem(.adaptive(minimum: 70))]
    
    @Binding var selectedEmoticon: String
    @Binding var selectedEmoticonURL: URL?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(emoticons, id: \.key) { emoticon in
                    Button(action: {
                        self.selectedEmoticon = emoticon.key
                        self.selectedEmoticonURL = emoticon.path
                    }) {
                        SVGImage(url: emoticon.path)
                            .frame(width: 40, height: 40)
                    }
                    .padding(4)
                }
            }
            .padding(.horizontal)
        }
    }
}





