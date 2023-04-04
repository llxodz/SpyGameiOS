//
//  SwipeCardDelegate.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

protocol SwipeCardDelegate: AnyObject {
    func cardDidBeginSwipe(_ card: SwipeCard)
    func cardDidCancelSwipe(_ card: SwipeCard)
    func cardDidContinueSwipe(_ card: SwipeCard)
    func cardDidFinishSwipeAnimation(_ card: SwipeCard)
    func cardDidSwipe(_ card: SwipeCard, withDirection direction: SwipeDirection)
    func cardDidTap(_ card: SwipeCard)
}
