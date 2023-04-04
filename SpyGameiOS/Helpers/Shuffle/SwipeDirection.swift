//
//  SwipeDirection.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

@objc public enum SwipeDirection: Int, CustomStringConvertible {
    
    case left, right, up, down
    
    public static let allDirections: [SwipeDirection] = [left, up, right, down]
    
    public var vector: CGVector {
        switch self {
        case .left: return CGVector(dx: -1, dy: 0)
        case .right: return CGVector(dx: 1, dy: 0)
        case .up: return CGVector(dx: 0, dy: -1)
        case .down: return CGVector(dx: 0, dy: 1)
        }
    }
    
    public var description: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .up: return "up"
        case .down: return "down"
        }
    }
}
