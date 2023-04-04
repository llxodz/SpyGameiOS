//
//  SpyEndpoint.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 16.03.2023.
//

import Foundation

enum SpyEndpoint: String {
    case allCategories = "/allCategories"
}

extension SpyEndpoint: BaseEndpoint {
    
    private static let baseUrl: String = "https://spy-game-backend.vercel.app"
    
    var url: URL {
        URL(string: SpyEndpoint.baseUrl + self.rawValue)!
    }
}
