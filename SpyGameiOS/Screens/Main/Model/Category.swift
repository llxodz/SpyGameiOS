//
//  Category.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 12.03.2023.
//

import Foundation

struct Category: Equatable {
    let id: Int
    let name: String
    var selected: Bool
}

extension Category {
   
    func withSelected(_ selected: Bool) -> Category {
        return Category(id: id, name: name, selected: selected)
    }
}
