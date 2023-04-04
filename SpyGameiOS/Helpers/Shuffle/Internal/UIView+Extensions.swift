//
//  UIView+Extensions.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 29.03.2023.
//

import UIKit

extension UIView {
    
    func setUserInteraction(_ isEnabled: Bool) {
        isUserInteractionEnabled = isEnabled
        for subview in subviews {
            subview.setUserInteraction(isEnabled)
        }
    }
}
