//
//  SwipeView.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

open class SwipeView: UIView {
    
    open var swipeDirections = SwipeDirection.allDirections
    
    public var panGestureRecognizer: UIPanGestureRecognizer {
        return internalPanGestureRecognizer
    }
    
    private lazy var internalPanGestureRecognizer = PanGestureRecognizer(target: self,
                                                                         action: #selector(handlePan))
    
    public var tapGestureRecognizer: UITapGestureRecognizer {
        return internalTapGestureRecognizer
    }
    
    private lazy var internalTapGestureRecognizer = TapGestureRecognizer(target: self,
                                                                         action: #selector(didTap))
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        addGestureRecognizer(internalPanGestureRecognizer)
        addGestureRecognizer(internalTapGestureRecognizer)
    }
    
    public func activeDirection() -> SwipeDirection? {
        return swipeDirections.reduce((CGFloat.zero, nil)) { [unowned self] lastResult, direction in
            let dragPercentage = self.dragPercentage(on: direction)
            return dragPercentage > lastResult.0 ? (dragPercentage, direction) : lastResult
        }.1
    }
    
    public func dragSpeed(on direction: SwipeDirection) -> CGFloat {
        let velocity = panGestureRecognizer.velocity(in: superview)
        return abs(direction.vector * CGVector(to: velocity))
    }
    
    public func dragPercentage(on direction: SwipeDirection) -> CGFloat {
        let translation = CGVector(to: panGestureRecognizer.translation(in: superview))
        let scaleFactor = 1 / minimumSwipeDistance(on: direction)
        let percentage = scaleFactor * (translation * direction.vector)
        return percentage < 0 ? 0 : percentage
    }
    
    open func minimumSwipeSpeed(on direction: SwipeDirection) -> CGFloat {
        return 1100
    }
    
    open func minimumSwipeDistance(on direction: SwipeDirection) -> CGFloat {
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 4
    }
    
    @objc
    open func didTap(_ recognizer: UITapGestureRecognizer) {}
    open func beginSwiping(_ recognizer: UIPanGestureRecognizer) {}
    open func continueSwiping(_ recognizer: UIPanGestureRecognizer) {}
    open func endSwiping(_ recognizer: UIPanGestureRecognizer) {
        if let direction = activeDirection() {
            if dragSpeed(on: direction) >= minimumSwipeSpeed(on: direction)
                || dragPercentage(on: direction) >= 1 {
                didSwipe(recognizer, with: direction)
                return
            }
        }
        didCancelSwipe(recognizer)
    }
    
    open func didSwipe(_ recognizer: UIPanGestureRecognizer, with direction: SwipeDirection) {}
    open func didCancelSwipe(_ recognizer: UIPanGestureRecognizer) {}
    
    // MARK: - Selectors
    @objc
    private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .possible, .began:
            beginSwiping(recognizer)
        case .changed:
            continueSwiping(recognizer)
        case .ended, .cancelled:
            endSwiping(recognizer)
        default:
            break
        }
    }
}
