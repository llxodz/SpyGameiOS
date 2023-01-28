//
//  BaseButton.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 08.01.2023.
//

import UIKit

open class TappableButton: UIButton, Tappable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateTapView(alpha: 0.5)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateTapView(alpha: 1)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateTapView(alpha: 1)
    }
}
