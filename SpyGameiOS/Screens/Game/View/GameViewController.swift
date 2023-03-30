//
//  GameViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 29.03.2023.
//

import UIKit
import SnapKit

final class GameViewController: BaseViewController {
    
    // UI
    private let shuffleStackView = SwipeCardStack()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubview(shuffleStackView)
    }
    
    private func configureLayout() {
        shuffleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
            $0.bottom.equalToSuperview().inset(52)
            $0.width.equalToSuperview()
        }
    }
    
    private func configureAppearance() {
        view.backgroundColor = .white
        
        shuffleStackView.dataSource = self
        shuffleStackView.delegate = self
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
