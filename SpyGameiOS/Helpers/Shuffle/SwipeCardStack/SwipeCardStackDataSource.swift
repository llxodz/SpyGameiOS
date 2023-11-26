//
//  SwipeCardStackDataSource.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

public protocol SwipeCardStackDataSource: AnyObject {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard
    func numberOfCards(in cardStack: SwipeCardStack) -> Int
}
