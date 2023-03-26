//
//  AnimatedPressButton.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 08.01.2023.
//

import UIKit

open class AnimatedPressButton: UIButton {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateTapView(alpha: 0.5)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateTapView(alpha: 1)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateTapView(alpha: 1)
    }
}
