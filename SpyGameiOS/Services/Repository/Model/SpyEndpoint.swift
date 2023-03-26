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
    
    private static let baseUrl: String = "http://192.168.0.103:3000"
    
    var url: URL {
        URL(string: SpyEndpoint.baseUrl + self.rawValue)!
    }
}
