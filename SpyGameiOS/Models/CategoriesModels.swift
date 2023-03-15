//
//  Categories.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 16.03.2023.
//

import Foundation

public enum NetworkState {
    case loading
    case success(Categories)
    case failed(Error)
}

public struct Categories: Decodable {
    let id: String
    let name: String
    let location: Location
}

struct Location: Decodable {
    let name: String
}
