//
//  AnimatedPressTableCell.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 14.03.2023.
//

import UIKit

open class AnimatedPressTableCell: UITableViewCell  {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateTapView(alpha: 0.3)
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
