//
//  NetworkEndpoint.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 16.03.2023.
//

import Foundation

protocol BaseEndpoint {
    var url: URL { get }
}

enum SpyEndpoint {
    case allCategories
}

extension SpyEndpoint: BaseEndpoint {
    
    var url: URL {
        switch self {
        case .allCategories: return URL(string: .spyBaseURL + "/allCategories")!
        }
    }
}
