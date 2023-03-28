//
//  Tappable.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 20.08.2022.
//

import Foundation
import UIKit

public protocol Tappable: AnyObject {
    
    func enableTapping(_ handler: @escaping () -> Void)
    
    func disableTapping()
}

public extension Tappable where Self: UIView {
    
    func enableTapping(_ handler: @escaping () -> Void) {
        isUserInteractionEnabled = true

        // Удаление Recognizer если он уже был
        disableTapping()

        let tapRecognizer = SpyTapGestureRecognizer(handler: handler)
        addGestureRecognizer(tapRecognizer)
    }

    func disableTapping() {
        if let recognizersToDelete = gestureRecognizers?.filter({ $0 is SpyTapGestureRecognizer }) {
            recognizersToDelete.forEach(removeGestureRecognizer)
        }
    }
}

private class SpyTapGestureRecognizer: UITapGestureRecognizer {
    
    private let handler: (() -> Void)?
    
    required init(handler: @escaping () -> Void) {
        self.handler = handler
        super.init(target: nil, action: nil)
        
        addTarget(self, action: #selector(tapHandler))
    }
    
    @objc private func tapHandler() {
        handler?()
    }
}
