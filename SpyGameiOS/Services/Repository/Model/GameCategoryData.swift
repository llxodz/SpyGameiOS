//
//  GameCategoryData.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 16.03.2023.
//

import Foundation

struct GameCategoryData: Decodable, Equatable {
    
    let id: Int
    let name: String
    let locations: [Location]
    
    struct Location: Decodable, Equatable {
        let name: String
    }
}
