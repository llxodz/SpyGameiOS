//
//  CategoriesState.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 17.03.2023.
//

import Foundation

enum CategoriesState: Equatable {
    case loading
    case success([GamingCategory])
    case failed
}
