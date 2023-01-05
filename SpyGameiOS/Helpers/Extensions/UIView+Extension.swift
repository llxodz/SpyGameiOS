//
//  UIView+Extension.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 18.08.2022.
//

import UIKit

extension UIView {
    
    /// Функции множественного добавления View
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
    
    /// Анимация нажатия Custom'ных кнопок
    func animateTapButton(alpha: CGFloat) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: UIView.AnimationOptions()
        ) {
            self.alpha = alpha
        }
    }
}
