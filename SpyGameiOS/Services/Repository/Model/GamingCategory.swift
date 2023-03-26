//
//  GamingCategory.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 16.03.2023.
//

import Foundation

public struct GamingCategory: Decodable {
    let id: Int
    let name: String
    let locations: [CategoryLocation]
}

struct CategoryLocation: Decodable {
    let name: String
}
