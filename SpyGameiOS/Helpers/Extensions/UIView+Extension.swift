//
//  UIView+Extension.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 18.08.2022.
//

import UIKit

extension UIView {
    
    // MARK: - Static
        
    static var clearView: UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
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
    func animateTapView(alpha: CGFloat, duration: CGFloat = 0.1) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions())
        {
            self.alpha = alpha
        }
    }
}
