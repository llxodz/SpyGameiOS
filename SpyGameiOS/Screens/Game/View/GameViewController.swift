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
    static let offAlpha: CGFloat = 0.25
    static let startButtonHeight: CGFloat = 56
}

final class GameViewController: BaseViewController {
    
    // UI
    private let shuffleStackView = SwipeCardStack()
    private let timerStackView = UIStackView()
    private let timerLabel = UILabel()
    private let startGameButton = TappableButton()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        addViews()
        configureLayout()
        configureAppearance()
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
        view.backgroundColor = Asset.mainBackgroundColor.color
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
        timerLabel.textColor = Asset.mainTextColor.color
        timerLabel.text = "2:00"
        // Button
        startGameButton.layer.cornerRadius = .baseRadius
        startGameButton.setTitle(L10n.FooterView.startGame, for: .normal)
        startGameButton.titleLabel?.font = Constants.boldFont
        startGameButton.setTitleColor(Asset.mainTextColor.color, for: .normal)
        startGameButton.setTitleColor(
            Asset.mainTextColor.color.withAlphaComponent(Constants.offAlpha),
            for: .disabled
        )
        startGameButton.backgroundColor = Asset.buttonBackgroundColor.color
    }
}

// MARK: - Extensions SwipeCardStack

extension GameViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return configureCard()
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        5
    }
    
    private func configureCard() -> SwipeCard {
        let card = SwipeCard()
        let cardView = CardView()
        card.swipeDirections = [.left, .right]
        card.content = cardView
        
        return card
    }
}

// MARK: - Extension Configurable

extension GameViewController: Configurable {

    struct Model {
        let value: Int
    }
    
    func configure(with model: Model) { }
}
