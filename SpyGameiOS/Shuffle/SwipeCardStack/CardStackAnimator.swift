//
//  CardStackAnimator.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

protocol CardStackAnimatable {
    func animateReset(_ cardStack: SwipeCardStack,
                      topCard: SwipeCard)
    func animateShift(_ cardStack: SwipeCardStack,
                      withDistance distance: Int,
                      animated: Bool,
                      completion: ((Bool) -> Void)?)
    func animateSwipe(_ cardStack: SwipeCardStack,
                      topCard: SwipeCard,
                      direction: SwipeDirection,
                      forced: Bool,
                      animated: Bool,
                      completion: ((Bool) -> Void)?)
    func animateUndo(_ cardStack: SwipeCardStack,
                     topCard: SwipeCard,
                     animated: Bool,
                     completion: ((Bool) -> Void)?)
    func removeAllCardAnimations(_ cardStack: SwipeCardStack)
    func removeBackgroundCardAnimations(_ cardStack: SwipeCardStack)
}


class CardStackAnimator: CardStackAnimatable {
    
    static let shared = CardStackAnimator()
    
    func animateReset(_ cardStack: SwipeCardStack,
                      topCard: SwipeCard) {
        removeBackgroundCardAnimations(cardStack)
        
        let duration = cardStack.animationOptions.resetDuration ?? topCard.animationOptions.totalResetDuration / 2
        Animator.animateKeyFrames(
            withDuration: duration,
            options: .allowUserInteraction,
            animations: {
                for (position, card) in cardStack.backgroundCards.enumerated() {
                    let transform = cardStack.transform(forCardAtPosition: position + 1)
                    Animator.addTransformKeyFrame(to: card, transform: transform)
                }
            },
            completion: nil)
    }
    
    func animateShift(_ cardStack: SwipeCardStack,
                      withDistance distance: Int,
                      animated: Bool,
                      completion: ((Bool) -> Void)?) {
        removeAllCardAnimations(cardStack)
        
        if !animated {
            for (position, value) in cardStack.visibleCards.enumerated() {
                value.card.transform = cardStack.transform(forCardAtPosition: position)
            }
            completion?(true)
            return
        }
        
        for (position, value) in cardStack.visibleCards.enumerated() {
            value.card.transform = cardStack.transform(forCardAtPosition: position + distance)
        }
        
        Animator.animateKeyFrames(
            withDuration: cardStack.animationOptions.shiftDuration,
            animations: {
                for (position, value) in cardStack.visibleCards.enumerated() {
                    let transform = cardStack.transform(forCardAtPosition: position)
                    Animator.addTransformKeyFrame(to: value.card, transform: transform)
                }
            },
            completion: completion)
    }
    
    func animateSwipe(_ cardStack: SwipeCardStack,
                      topCard: SwipeCard,
                      direction: SwipeDirection,
                      forced: Bool,
                      animated: Bool,
                      completion: ((Bool) -> Void)?) {
        removeBackgroundCardAnimations(cardStack)
        
        if !animated {
            for (position, value) in cardStack.visibleCards.enumerated() {
                cardStack.layoutCard(value.card, at: position)
            }
            completion?(true)
            return
        }
        
        let delay = swipeDelay(for: topCard, forced: forced)
        let duration = swipeDuration(cardStack,
                                     topCard: topCard,
                                     direction: direction,
                                     forced: forced)
        
        if cardStack.visibleCards.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + duration) {
                completion?(true)
            }
            return
        }
        
        Animator.animateKeyFrames(
            withDuration: duration,
            delay: delay,
            animations: {
                for (position, value) in cardStack.visibleCards.enumerated() {
                    Animator.addKeyFrame {
                        cardStack.layoutCard(value.card, at: position)
                    }
                }
            },
            completion: completion)
    }
    
    func animateUndo(_ cardStack: SwipeCardStack,
                     topCard: SwipeCard,
                     animated: Bool,
                     completion: ((Bool) -> Void)?) {
        removeBackgroundCardAnimations(cardStack)
        
        if !animated {
            for (position, card) in cardStack.backgroundCards.enumerated() {
                cardStack.layoutCard(card, at: position + 1)
            }
            completion?(true)
            return
        }
        
        for (position, card) in cardStack.backgroundCards.enumerated() {
            card.transform = cardStack.transform(forCardAtPosition: position)
        }
        
        let duration = cardStack.animationOptions.undoDuration ?? topCard.animationOptions.totalReverseSwipeDuration / 2
        Animator.animateKeyFrames(
            withDuration: duration,
            animations: {
                for (position, card) in cardStack.backgroundCards.enumerated() {
                    Animator.addKeyFrame {
                        cardStack.layoutCard(card, at: position + 1)
                    }
                }
            },
            completion: completion)
    }
    
    func removeBackgroundCardAnimations(_ cardStack: SwipeCardStack) {
        cardStack.backgroundCards.forEach { $0.removeAllAnimations() }
    }
    
    func removeAllCardAnimations(_ cardStack: SwipeCardStack) {
        cardStack.visibleCards.forEach { $0.card.removeAllAnimations() }
    }
    
    func swipeDelay(for topCard: SwipeCard, forced: Bool) -> TimeInterval {
        let duration = topCard.animationOptions.totalSwipeDuration
        let relativeOverlayDuration = topCard.animationOptions.relativeSwipeOverlayFadeDuration
        let delay = duration * TimeInterval(relativeOverlayDuration)
        return forced ? delay : 0
    }
    
    func swipeDuration(_ cardStack: SwipeCardStack,
                       topCard: SwipeCard,
                       direction: SwipeDirection,
                       forced: Bool) -> TimeInterval {
        if let swipeDuration = cardStack.animationOptions.swipeDuration {
            return swipeDuration
        }
        
        if forced {
            return topCard.animationOptions.totalSwipeDuration / 2
        }
        
        let velocityFactor = topCard.dragSpeed(on: direction) / topCard.minimumSwipeSpeed(on: direction)
        
        if velocityFactor < 1.0 {
            return topCard.animationOptions.totalSwipeDuration / 2
        }
        
        return 1.0 / (2.0 * TimeInterval(velocityFactor))
    }
}
