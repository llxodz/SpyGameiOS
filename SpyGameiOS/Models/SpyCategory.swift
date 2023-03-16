//
//  Categories.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 16.03.2023.
//

import Foundation

public struct SpyCategory: Decodable {
    let id: String
    let name: String
    let location: Location
}

struct Location: Decodable {
    let name: String
}
