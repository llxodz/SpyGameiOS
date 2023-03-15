//
//  CellType.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 14.03.2023.
//

import Foundation

enum CellType {
    case playes
    case spies
    case timer
    case categories
}

extension CellType: RawRepresentable, CaseIterable {
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .playes
        case 1: self = .spies
        case 2: self = .timer
        case 3: self = .categories
        default: return nil
        }
    }
    
    var rawValue: Int {
        switch self {
        case .playes: return 0
        case .spies: return 1
        case .timer: return 2
        case .categories: return 3
        }
    }
}
