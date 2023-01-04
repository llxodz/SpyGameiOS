//
//  UIView+Extension.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 18.08.2022.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
    
    func startAnimation(alpha: CGFloat) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: UIView.AnimationOptions()
        ) {
            self.alpha = alpha
        }
    }
}
