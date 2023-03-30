//
//  SwipeCardStackDelegate.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

@objc public protocol SwipeCardStackDelegate: AnyObject {
    
    @objc
    optional func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int)
    
    @objc
    optional func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection)
    
    @objc
    optional func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection)
    
    @objc
    optional func didSwipeAllCards(_ cardStack: SwipeCardStack)
}
