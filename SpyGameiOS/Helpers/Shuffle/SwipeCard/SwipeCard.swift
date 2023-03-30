//
//  SwipeCard.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

open class SwipeCard: SwipeView {
    
    open var animationOptions = CardAnimationOptions()
    
    public var content: UIView? {
        didSet {
            if let content = content {
                oldValue?.removeFromSuperview()
                addSubview(content)
            }
        }
    }
    
    public var footer: UIView? {
        didSet {
            if let footer = footer {
                oldValue?.removeFromSuperview()
                addSubview(footer)
            }
        }
    }
    
    public var footerHeight: CGFloat = 100 {
        didSet {
            setNeedsLayout()
        }
    }
    
    weak var delegate: SwipeCardDelegate?
    
    var touchLocation: CGPoint? {
        return internalTouchLocation
    }
    
    private var internalTouchLocation: CGPoint?
    
    private let overlayContainer = UIView()
    private var overlays = [SwipeDirection: UIView]()
    
    private var animator: CardAnimatable = CardAnimator.shared
    
    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    convenience init(animator: CardAnimatable) {
        self.init(frame: .zero)
        self.animator = animator
    }
    
    private func initialize() {
        addSubview(overlayContainer)
        overlayContainer.setUserInteraction(false)
    }
    
    // MARK: - Layout & Swipe Transform
    override open func layoutSubviews() {
        super.layoutSubviews()
        footer?.frame = CGRect(x: 0, y: bounds.height - footerHeight, width: bounds.width, height: footerHeight)
        
        // Content
        if let content = content {
            if let footer = footer, footer.isOpaque {
                content.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - footerHeight)
            } else {
                content.frame = bounds
            }
            sendSubviewToBack(content)
        }
        
        if footer != nil {
            overlayContainer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - footerHeight)
        } else {
            overlayContainer.frame = bounds
        }
        bringSubviewToFront(overlayContainer)
        overlays.values.forEach { $0.frame = overlayContainer.bounds }
    }
    
    func swipeTransform() -> CGAffineTransform {
        let dragTranslation = panGestureRecognizer.translation(in: self)
        let translation = CGAffineTransform(translationX: dragTranslation.x,
                                            y: dragTranslation.y)
        let rotation = CGAffineTransform(rotationAngle: swipeRotationAngle())
        return translation.concatenating(rotation)
    }
    
    func swipeRotationAngle() -> CGFloat {
        let superviewTranslation = panGestureRecognizer.translation(in: superview)
        let rotationStrength = min(superviewTranslation.x / UIScreen.main.bounds.width, 1)
        return swipeRotationDirectionY()
        * rotationStrength
        * animationOptions.maximumRotationAngle
    }
    
    func swipeRotationDirectionY() -> CGFloat {
        if let touchPoint = touchLocation {
            return (touchPoint.y < bounds.height / 2) ? 1 : -1
        }
        return 0
    }
    
    func swipeOverlayPercentage(forDirection direction: SwipeDirection) -> CGFloat {
        if direction != activeDirection() { return 0 }
        let totalPercentage = swipeDirections.reduce(0) { sum, direction in
            return sum + dragPercentage(on: direction)
        }
        let actualPercentage = 2 * dragPercentage(on: direction) - totalPercentage
        return max(0, min(actualPercentage, 1))
    }
    
    // MARK: - Overrides
    override open func didTap(_ recognizer: UITapGestureRecognizer) {
        super.didTap(recognizer)
        internalTouchLocation = recognizer.location(in: self)
        delegate?.cardDidTap(self)
    }
    
    override open func beginSwiping(_ recognizer: UIPanGestureRecognizer) {
        super.beginSwiping(recognizer)
        internalTouchLocation = recognizer.location(in: self)
        delegate?.cardDidBeginSwipe(self)
        animator.removeAllAnimations(on: self)
    }
    
    override open func continueSwiping(_ recognizer: UIPanGestureRecognizer) {
        super.continueSwiping(recognizer)
        delegate?.cardDidContinueSwipe(self)
        
        transform = swipeTransform()
        
        for (direction, overlay) in overlays {
            overlay.alpha = swipeOverlayPercentage(forDirection: direction)
        }
    }
    
    override open func didSwipe(_ recognizer: UIPanGestureRecognizer,
                                with direction: SwipeDirection) {
        super.didSwipe(recognizer, with: direction)
        delegate?.cardDidSwipe(self, withDirection: direction)
        swipeAction(direction: direction, forced: false)
    }
    
    override open func didCancelSwipe(_ recognizer: UIPanGestureRecognizer) {
        super.didCancelSwipe(recognizer)
        delegate?.cardDidCancelSwipe(self)
        animator.animateReset(on: self)
    }
    
    // MARK: - Main Methods
    public func setOverlay(_ overlay: UIView?, forDirection direction: SwipeDirection) {
        overlays[direction]?.removeFromSuperview()
        overlays[direction] = overlay
        
        if let overlay = overlay {
            overlayContainer.addSubview(overlay)
            overlay.alpha = 0
            overlay.setUserInteraction(false)
        }
    }
    
    public func setOverlays(_ overlays: [SwipeDirection: UIView]) {
        for (direction, overlay) in overlays {
            setOverlay(overlay, forDirection: direction)
        }
    }
    
    public func overlay(forDirection direction: SwipeDirection) -> UIView? {
        return overlays[direction]
    }
    
    public func swipe(direction: SwipeDirection) {
        swipeAction(direction: direction, forced: true)
    }
    
    func swipeAction(direction: SwipeDirection, forced: Bool) {
        isUserInteractionEnabled = false
        animator.animateSwipe(on: self,
                              direction: direction,
                              forced: forced) { [weak self] finished in
            if let strongSelf = self, finished {
                strongSelf.delegate?.cardDidFinishSwipeAnimation(strongSelf)
            }
        }
    }
    
    public func reverseSwipe(from direction: SwipeDirection) {
        isUserInteractionEnabled = false
        animator.animateReverseSwipe(on: self, from: direction) { [weak self] finished in
            if finished {
                self?.isUserInteractionEnabled = true
            }
        }
    }
    
    public func removeAllAnimations() {
        layer.removeAllAnimations()
        animator.removeAllAnimations(on: self)
    }
}
