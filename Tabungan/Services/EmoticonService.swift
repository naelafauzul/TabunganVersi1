//
//  EmoticonService.swift
//  Tabungan
//
//  Created by Naela Fauzul Muna on 22/03/24.
//

import Foundation
import UIKit
import Supabase


class EmoticonService: ObservableObject {
    static let shared = EmoticonService()
    
    static let baseKeyEmoticons = "celengan/emoticons"
    private static let totalImages = 59
    private static let baseImageUrl = "https://atijrsvztjdenjmnsxzs.supabase.co/storage/v1/object/public/"
    
    static func generatedKey(index: Int) -> String {
        "\(baseKeyEmoticons)/emoticon_\(index).svg"
    }
    
    static func generatedPath(index: Int) -> URL? {
        URL(string: "\(baseImageUrl)\(generatedKey(index: index))")
    }
    
    static func getEmoticons() -> [Emoticon] {
        (1...totalImages).compactMap { index in
            guard let path = generatedPath(index: index) else { return nil }
            return Emoticon(id: index, key: generatedKey(index: index), path: path)
        }
    }
    
    static func getEmoticon(byKey key: String) -> Emoticon? {
        getEmoticons().first { $0.key == key }
    }
    
    
}
