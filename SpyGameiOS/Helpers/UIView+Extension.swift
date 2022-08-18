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
    
    private func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
}
