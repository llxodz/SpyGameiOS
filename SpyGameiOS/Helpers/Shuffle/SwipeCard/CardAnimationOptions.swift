//
//  CardAnimationOptions.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

public struct CardAnimationOptions {
    
    public var maximumRotationAngle: CGFloat = .pi / 10 {
        didSet {
            maximumRotationAngle = max(-.pi / 2, min(maximumRotationAngle, .pi / 2))
        }
    }
    
    public var relativeReverseSwipeOverlayFadeDuration: Double = 0.15 {
        didSet {
            relativeReverseSwipeOverlayFadeDuration = max(0, min(relativeReverseSwipeOverlayFadeDuration, 1))
        }
    }
    
    public var relativeSwipeOverlayFadeDuration: Double = 0.15 {
        didSet {
            relativeSwipeOverlayFadeDuration = max(0, min(relativeSwipeOverlayFadeDuration, 1))
        }
    }
    
    public var resetSpringDamping: CGFloat = 0.5 {
        didSet {
            resetSpringDamping = max(0, min(resetSpringDamping, 1))
        }
    }
    
    public var totalResetDuration: TimeInterval = 0.6 {
        didSet {
            totalResetDuration = max(.leastNormalMagnitude, totalResetDuration)
        }
    }
    
    public var totalReverseSwipeDuration: TimeInterval = 0.25 {
        didSet {
            totalReverseSwipeDuration = max(.leastNormalMagnitude, totalReverseSwipeDuration)
        }
    }
    
    public var totalSwipeDuration: TimeInterval = 0.7 {
        didSet {
            totalSwipeDuration = max(.leastNormalMagnitude, totalSwipeDuration)
        }
    }
}
