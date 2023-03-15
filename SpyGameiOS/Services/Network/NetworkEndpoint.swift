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
    case fetchCategories
}

extension SpyEndpoint: BaseEndpoint {
    
    var url: URL {
        switch self {
        case .fetchCategories: return URL(string: .spyBaseURL + "/allCategories")!
        }
    }
}
