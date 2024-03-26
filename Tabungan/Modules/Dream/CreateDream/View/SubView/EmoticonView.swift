//
//  EmoticonView.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 22/03/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct EmoticonView: View {
    private let emoticons = EmoticonService.getEmoticons()
    private let columns = [GridItem(.adaptive(minimum: 70))]
    
    @Binding var selectedEmoticon : String
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(emoticons) { emoticon in
                    Button(action: {
                        self.selectedEmoticon = emoticon.key
                    }) {
                        if emoticon.path.absoluteString.lowercased().hasSuffix("svg") {
                            WebImage(url: emoticon.path, options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                        } else {
                            AsyncImage(url: emoticon.path) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                         .aspectRatio(contentMode: .fit)
                                         .frame(width: 70, height: 70)
                                case .failure:
                                    Image(systemName: "photo")
                                        .foregroundColor(.red)
                                        .frame(width: 70, height: 70)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .padding(4)
                }
            }
            .padding(.horizontal)
        }
    }
}



//#Preview {
//    EmoticonView(selectedEmoticonKey: "emot")
//}
