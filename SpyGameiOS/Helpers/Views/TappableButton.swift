//
//  TappableButton.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 14.03.2023.
//

import UIKit

class TappableButton: AnimatedPressButton, Tappable {
    
    // Private
    private var insets: CGFloat = 0
    
    // MARK: - Lifecycle
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -1 * abs(insets), dy: -1 * abs(insets)).contains(point)
    }
    
    // MARK: - Public
    
    func setInsetsOffset(_ insets: CGFloat) {
        self.insets = insets
    }
}
