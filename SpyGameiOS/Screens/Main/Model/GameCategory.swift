//
//  Category.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 12.03.2023.
//

import Foundation

struct GameCategory: Equatable {
    let data: GameCategoryData
    var selected: Bool
}

extension GameCategory {
   
    func withSelected(_ selected: Bool) -> GameCategory {
        return GameCategory(data: data, selected: selected)
    }
}
