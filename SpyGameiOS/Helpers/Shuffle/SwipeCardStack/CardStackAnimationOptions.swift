//
//  CardStackAnimationOptions.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

public struct CardStackAnimationOptions {
    
    public var resetDuration: TimeInterval? {
        didSet {
            if let duration = resetDuration {
                resetDuration = max(.leastNormalMagnitude, duration)
            }
        }
    }
    
    public var shiftDuration: TimeInterval = 0.1 {
        didSet {
            shiftDuration = max(.leastNormalMagnitude, shiftDuration)
        }
    }
    
    public var swipeDuration: TimeInterval? {
        didSet {
            if let duration = swipeDuration {
                swipeDuration = max(.leastNormalMagnitude, duration)
            }
        }
    }
    
    public var undoDuration: TimeInterval? {
        didSet {
            if let duration = undoDuration {
                undoDuration = max(.leastNormalMagnitude, duration)
            }
        }
    }
}
