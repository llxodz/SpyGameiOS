//
//  SwipeCardStack.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 28.03.2023.
//

import UIKit

open class SwipeCardStack: UIView, SwipeCardDelegate, UIGestureRecognizerDelegate {
    
    struct Card {
        var index: Int
        var card: SwipeCard
    }
    
    open var animationOptions = CardStackAnimationOptions()
    open var shouldRecognizeHorizontalDrag: Bool = true
    open var shouldRecognizeVerticalDrag: Bool = true
    
    public weak var delegate: SwipeCardStackDelegate?
    public weak var dataSource: SwipeCardStackDataSource? {
        didSet {
            reloadData()
        }
    }
    
    public var cardStackInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var topCardIndex: Int? {
        return visibleCards.first?.index
    }
    
    var numberOfVisibleCards: Int = 2
    var visibleCards: [Card] = []
    var topCard: SwipeCard? {
        return visibleCards.first?.card
    }
    
    var backgroundCards: [SwipeCard] {
        return Array(visibleCards.dropFirst()).map { $0.card }
    }
    
    var isEnabled: Bool {
        return !isAnimating && (topCard?.isUserInteractionEnabled ?? true)
    }
    
    var isAnimating: Bool = false
    
    let cardContainer = UIView()
    
    private var animator: CardStackAnimatable = CardStackAnimator.shared
    private var stateManager: CardStackStateManagable = CardStackStateManager()
    
    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    convenience init(animator: CardStackAnimatable,
                     stateManager: CardStackStateManagable) {
        self.init(frame: .zero)
        self.animator = animator
        self.stateManager = stateManager
    }
    
    private func initialize() {
        addSubview(cardContainer)
    }
    
    // MARK: - Layout & Transform
    override open func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width - (cardStackInsets.left + cardStackInsets.right)
        let height = bounds.height - (cardStackInsets.top + cardStackInsets.bottom)
        cardContainer.frame = CGRect(x: cardStackInsets.left, y: cardStackInsets.top, width: width, height: height)
        
        for (position, value) in visibleCards.enumerated() {
            layoutCard(value.card, at: position)
        }
    }
    
    func layoutCard(_ card: SwipeCard, at position: Int) {
        card.transform = .identity
        card.frame = CGRect(origin: .zero, size: cardContainer.frame.size)
        card.transform = transform(forCardAtPosition: position)
        card.isUserInteractionEnabled = position == 0
    }
    
    func scaleFactor(forCardAtPosition position: Int) -> CGPoint {
        return position == 0 ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.95, y: 0.95)
    }
    
    func transform(forCardAtPosition position: Int) -> CGAffineTransform {
        let cardScaleFactor = scaleFactor(forCardAtPosition: position)
        return CGAffineTransform(scaleX: cardScaleFactor.x, y: cardScaleFactor.y)
    }
    
    func backgroundCardDragTransform(topCard: SwipeCard, currentPosition: Int) -> CGAffineTransform {
        let panTranslation = topCard.panGestureRecognizer.translation(in: self)
        let minimumSideLength = min(bounds.width, bounds.height)
        let percentage = max(min(2 * abs(panTranslation.x) / minimumSideLength, 1),
                             min(2 * abs(panTranslation.y) / minimumSideLength, 1))
        
        let currentScale = scaleFactor(forCardAtPosition: currentPosition)
        let nextScale = scaleFactor(forCardAtPosition: currentPosition - 1)
        
        let scaleX = (1 - percentage) * currentScale.x + percentage * nextScale.x
        let scaleY = (1 - percentage) * currentScale.y + percentage * nextScale.y
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    // MARK: - Gesture Recognizers
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let topCard = topCard, topCard.panGestureRecognizer == gestureRecognizer else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        
        let velocity = topCard.panGestureRecognizer.velocity(in: self)
        
        if abs(velocity.x) > abs(velocity.y) {
            return shouldRecognizeHorizontalDrag
        }
        
        if abs(velocity.x) < abs(velocity.y) {
            return shouldRecognizeVerticalDrag
        }
        
        return topCard.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    // MARK: - Main Methods
    public func swipe(_ direction: SwipeDirection, animated: Bool) {
        if !isEnabled { return }
        
        if animated {
            topCard?.swipe(direction: direction)
        } else {
            topCard?.removeFromSuperview()
        }
        
        if let topCard = topCard {
            swipeAction(topCard: topCard,
                        direction: direction,
                        forced: true,
                        animated: animated)
        }
    }
    
    func swipeAction(topCard: SwipeCard,
                     direction: SwipeDirection,
                     forced: Bool,
                     animated: Bool) {
        guard let swipedIndex = topCardIndex else { return }
        stateManager.swipe(direction)
        visibleCards.remove(at: 0)
        
        if (stateManager.remainingIndices.count - visibleCards.count) > 0 {
            let bottomCardIndex = stateManager.remainingIndices[visibleCards.count]
            if let card = loadCard(at: bottomCardIndex) {
                insertCard(Card(index: bottomCardIndex, card: card), at: visibleCards.count)
            }
        }
        
        delegate?.cardStack?(self, didSwipeCardAt: swipedIndex, with: direction)
        
        if stateManager.remainingIndices.isEmpty {
            delegate?.didSwipeAllCards?(self)
            return
        }
        
        isAnimating = true
        animator.animateSwipe(self,
                              topCard: topCard,
                              direction: direction,
                              forced: forced,
                              animated: animated) { [weak self] finished in
            if finished {
                self?.isAnimating = false
            }
        }
    }
    
    public func undoLastSwipe(animated: Bool) {
        if !isEnabled { return }
        guard let previousSwipe = stateManager.undoSwipe() else { return }
        
        reloadVisibleCards()
        delegate?.cardStack?(self, didUndoCardAt: previousSwipe.index, from: previousSwipe.direction)
        
        if animated {
            topCard?.reverseSwipe(from: previousSwipe.direction)
        }
        
        isAnimating = true
        if let topCard = topCard {
            animator.animateUndo(self,
                                 topCard: topCard,
                                 animated: animated) { [weak self] finished in
                if finished {
                    self?.isAnimating = false
                }
            }
        }
    }
    
    public func shift(withDistance distance: Int = 1, animated: Bool) {
        if !isEnabled || distance == 0 || visibleCards.count <= 1 { return }
        
        stateManager.shift(withDistance: distance)
        reloadVisibleCards()
        
        isAnimating = true
        animator.animateShift(self,
                              withDistance: distance,
                              animated: animated) { [weak self] finished in
            if finished {
                self?.isAnimating = false
            }
        }
    }
    
    // MARK: - Data Source
    public func reloadData() {
        guard let dataSource = dataSource else { return }
        let numberOfCards = dataSource.numberOfCards(in: self)
        stateManager.reset(withNumberOfCards: numberOfCards)
        reloadVisibleCards()
        isAnimating = false
    }
    
    public func card(forIndexAt index: Int) -> SwipeCard? {
        for value in visibleCards where value.index == index {
            return value.card
        }
        return nil
    }
    
    func reloadVisibleCards() {
        visibleCards.forEach { $0.card.removeFromSuperview() }
        visibleCards.removeAll()
        
        let numberOfCards = min(stateManager.remainingIndices.count, numberOfVisibleCards)
        for position in 0..<numberOfCards {
            let index = stateManager.remainingIndices[position]
            if let card = loadCard(at: index) {
                insertCard(Card(index: index, card: card), at: position)
            }
        }
    }
    
    func insertCard(_ value: Card, at position: Int) {
        cardContainer.insertSubview(value.card, at: visibleCards.count - position)
        layoutCard(value.card, at: position)
        visibleCards.insert(value, at: position)
    }
    
    func loadCard(at index: Int) -> SwipeCard? {
        let card = dataSource?.cardStack(self, cardForIndexAt: index)
        card?.delegate = self
        card?.panGestureRecognizer.delegate = self
        return card
    }
    
    // MARK: - State Management
    public func positionforCard(at index: Int) -> Int? {
        return stateManager.remainingIndices.firstIndex(of: index)
    }
    
    public func numberOfRemainingCards() -> Int {
        return stateManager.remainingIndices.count
    }
    
    public func swipedCards() -> [Int] {
        return stateManager.swipes.map { $0.index }
    }
    
    public func insertCard(atIndex index: Int, position: Int) {
        guard let dataSource = dataSource else { return }
        
        let oldNumberOfCards = stateManager.totalIndexCount
        let newNumberOfCards = dataSource.numberOfCards(in: self)
        
        stateManager.insert(index, at: position)
        
        if newNumberOfCards != oldNumberOfCards + 1 {
            let errorString = StringUtils.createInvalidUpdateErrorString(newCount: newNumberOfCards,
                                                                         oldCount: oldNumberOfCards,
                                                                         insertedCount: 1)
            fatalError(errorString)
        }
        
        reloadVisibleCards()
    }
    
    public func appendCards(atIndices indices: [Int]) {
        guard let dataSource = dataSource else { return }
        
        let oldNumberOfCards = stateManager.totalIndexCount
        let newNumberOfCards = dataSource.numberOfCards(in: self)
        
        for index in indices {
            stateManager.insert(index, at: numberOfRemainingCards())
        }
        
        if newNumberOfCards != oldNumberOfCards + indices.count {
            let errorString = StringUtils.createInvalidUpdateErrorString(newCount: newNumberOfCards,
                                                                         oldCount: oldNumberOfCards,
                                                                         insertedCount: indices.count)
            fatalError(errorString)
        }
        
        reloadVisibleCards()
    }
    
    public func deleteCards(atIndices indices: [Int]) {
        guard let dataSource = dataSource else { return }
        
        let oldNumberOfCards = stateManager.totalIndexCount
        let newNumberOfCards = dataSource.numberOfCards(in: self)
        
        if newNumberOfCards != oldNumberOfCards - indices.count {
            let errorString = StringUtils.createInvalidUpdateErrorString(newCount: newNumberOfCards,
                                                                         oldCount: oldNumberOfCards,
                                                                         deletedCount: indices.count)
            fatalError(errorString)
        }
        
        stateManager.delete(indices)
        reloadVisibleCards()
    }
    
    public func deleteCards(atPositions positions: [Int]) {
        guard let dataSource = dataSource else { return }
        
        let oldNumberOfCards = stateManager.totalIndexCount
        let newNumberOfCards = dataSource.numberOfCards(in: self)
        
        if newNumberOfCards != oldNumberOfCards - positions.count {
            let errorString = StringUtils.createInvalidUpdateErrorString(newCount: newNumberOfCards,
                                                                         oldCount: oldNumberOfCards,
                                                                         deletedCount: positions.count)
            fatalError(errorString)
        }
        
        stateManager.delete(indicesAtPositions: positions)
        reloadVisibleCards()
    }
    
    // MARK: - SwipeCardDelegate
    func cardDidTap(_ card: SwipeCard) {
        guard let topCardIndex = topCardIndex else { return }
        delegate?.cardStack?(self, didSelectCardAt: topCardIndex)
    }
    
    func cardDidBeginSwipe(_ card: SwipeCard) {
        animator.removeBackgroundCardAnimations(self)
    }
    
    func cardDidContinueSwipe(_ card: SwipeCard) {
        for (position, backgroundCard) in backgroundCards.enumerated() {
            backgroundCard.transform = backgroundCardDragTransform(topCard: card, currentPosition: position + 1)
        }
    }
    
    func cardDidCancelSwipe(_ card: SwipeCard) {
        animator.animateReset(self, topCard: card)
    }
    
    func cardDidFinishSwipeAnimation(_ card: SwipeCard) {
        card.removeFromSuperview()
    }
    
    func cardDidSwipe(_ card: SwipeCard, withDirection direction: SwipeDirection) {
        swipeAction(topCard: card, direction: direction, forced: false, animated: true)
    }
}
