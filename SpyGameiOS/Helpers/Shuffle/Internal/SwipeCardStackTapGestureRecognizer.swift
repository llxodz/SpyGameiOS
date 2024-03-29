//
//  SwipeCardStackTapGestureRecognizer.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

class SwipeCardStackTapGestureRecognizer: UITapGestureRecognizer {
    
    private weak var testTarget: AnyObject?
    private var testAction: Selector?
    
    private var testLocation: CGPoint?
    
    override init(target: Any?, action: Selector?) {
        testTarget = target as AnyObject
        testAction = action
        super.init(target: target, action: action)
    }
    
    override func location(in view: UIView?) -> CGPoint {
        return testLocation ?? super.location(in: view)
    }
    
    func performTap(withLocation location: CGPoint?) {
        testLocation = location
        if let action = testAction {
            testTarget?.performSelector(onMainThread: action,
                                        with: self,
                                        waitUntilDone: true)
        }
    }
}
