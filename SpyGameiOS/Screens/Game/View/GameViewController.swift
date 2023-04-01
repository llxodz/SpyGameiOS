//
//  GameViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 29.03.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let boldFont: UIFont = FontFamily.Montserrat.bold.font(size: 18)
    static let semiBoldFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 14)
    static let alphaBackground: CGFloat = 0.5
    static let durationOfAnimation: CGFloat = 0.66
    static let offAlpha: CGFloat = 0.25
    static let startButtonHeight: CGFloat = 56
}

final class GameViewController: BaseViewController {
    
    // UI
    private let shuffleStackView = SwipeCardStack()
    private let timerStackView = UIStackView()
    private let timerLabel = UILabel()
    private let startGameButton = TappableButton()
    
    // TODO: - Удалить отсюда
    private var cards: [CardView.Player] = [
        CardView.Player(type: .spy, word: "Прикол"),
        CardView.Player(type: .common, word: "Прикол"),
        CardView.Player(type: .spy, word: "Прикол"),
        CardView.Player(type: .common, word: "Прикол"),
    ]
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActions()
    }
    
    // MARK: - Actions
    
    private func configureActions() {
        startGameButton.enableTapping { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubviews(timerStackView, shuffleStackView)
        timerStackView.addArrangedSubview(timerLabel)
        timerStackView.addArrangedSubview(startGameButton)
    }
    
    private func configureLayout() {
        shuffleStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.height.equalTo(view.bounds.height / 2)
        }
        timerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
        }
        startGameButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.height.equalTo(Constants.startButtonHeight)
        }
    }
    
    private func configureAppearance() {
        view.backgroundColor = Asset.Colors.mainBackgroundColor.color
        // Shuffle
        shuffleStackView.dataSource = self
        shuffleStackView.delegate = self
        // Stack View
        timerStackView.alignment = .center
        timerStackView.axis = .vertical
        timerStackView.spacing = CGFloat.baseMargin
        // Label
        timerLabel.textAlignment = .center
        timerLabel.font = Constants.boldFont
        timerLabel.textColor = Asset.Colors.mainTextColor.color
        timerLabel.text = "2:00"
        // Button
        startGameButton.layer.cornerRadius = .baseRadius
        startGameButton.setTitle(L10n.FooterView.startGame, for: .normal)
        startGameButton.titleLabel?.font = Constants.boldFont
        startGameButton.setTitleColor(Asset.Colors.mainTextColor.color, for: .normal)
        startGameButton.backgroundColor = Asset.Colors.buttonBackgroundColor.color
    }
}

// MARK: - Extensions SwipeCardStack

extension GameViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return configureCard()
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        if !cards[index].isCardOpen {
            guard let card = cardStack.card(forIndexAt: index) else { return }
            
            UIView.transition(
                with: card,
                duration: Constants.durationOfAnimation,
                options: [.curveEaseOut, .transitionFlipFromRight],
                animations: {
                    (card.content as? CardView)?.configure(with: self.cards[index])
                },
                completion: nil
            )
            
            cards[index].isCardOpen = true
        }
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        cards.count
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        shuffleStackView.isHidden = true
    }
    
    private func configureCard() -> SwipeCard {
        let card = SwipeCard()
        let cardView = CardView()
        card.swipeDirections = [.left, .right]
        card.content = cardView
        
        return card
    }
}
