//
//  CGPoint+Extensions.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

extension CGPoint {
    
    init(_ vector: CGVector) {
        self = CGPoint(x: vector.dx, y: vector.dy)
    }
}
