//
//  GameViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 29.03.2023.
//

import UIKit
import SnapKit
import Combine

private enum Constants {
    static let buttonFont: UIFont = FontFamily.Montserrat.bold.font(size: 18)
    static let timerFont: UIFont = FontFamily.Montserrat.bold.font(size: 36)
    static let durationOfAnimation: CGFloat = 0.66
    static let startButtonHeight: CGFloat = 56
}

final class GameViewController: BaseViewController {
    
    // Dependencies
    private let viewModel: GameViewModel
    
    // UI
    private let shuffleStackView = SwipeCardStack()
    private let timerLabel = UILabel()
    private let startGameButton = TappableButton()
    
    // Private property
    private let tapCard = PassthroughSubject<Void, Never>()
    private let didSwipeCard = PassthroughSubject<Void, Never>()
    private let didSwipeAllCards = PassthroughSubject<Void, Never>()
    private let start = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        configureActions()
    }
    
    // MARK: - Binding & Actions
    
    private func binding() {
        let output = viewModel.transform(input: GameViewModel.Input(
            tapCard: tapCard.eraseToAnyPublisher(),
            didSwipeCard: didSwipeCard.eraseToAnyPublisher(),
            didSwipeAllCards: didSwipeAllCards.eraseToAnyPublisher(),
            start: start.eraseToAnyPublisher()
        ))
        
        output.showStart
            .sink { [weak self] in
                guard let self = self else { return }
                self.shuffleStackView.isUserInteractionEnabled = false
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.3) {
                    self.startGameButton.alpha = 1
                    self.timerLabel.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
        output.updateTime
            .sink { [weak self] text in
                self?.timerLabel.text = text
            }
            .store(in: &cancellables)
        
        viewModel.requestAuthorization()
    }
    
    private func configureActions() {
        startGameButton.enableTapping { [weak self] in
            self?.start.send()
        }
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubviews(timerLabel, startGameButton, shuffleStackView)
    }
    
    private func configureLayout() {
        shuffleStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.height.equalTo(view.bounds.height / 2)
        }
        timerLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        startGameButton.snp.makeConstraints {
            $0.height.equalTo(Constants.startButtonHeight)
            $0.leading.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureAppearance() {
        view.backgroundColor = Asset.Colors.mainBackgroundColor.color
        // Shuffle
        shuffleStackView.dataSource = self
        shuffleStackView.delegate = self
        // Label
        timerLabel.textAlignment = .center
        timerLabel.font = Constants.timerFont
        timerLabel.textColor = Asset.Colors.mainTextColor.color
        // Button
        startGameButton.layer.cornerRadius = .baseRadius
        startGameButton.setTitle(L10n.FooterView.startGame, for: .normal)
        startGameButton.titleLabel?.font = Constants.buttonFont
        startGameButton.setTitleColor(Asset.Colors.mainTextColor.color, for: .normal)
        startGameButton.backgroundColor = Asset.Colors.buttonBackgroundColor.color
        // Default
        startGameButton.alpha = 0
        timerLabel.alpha = 0
    }
}

// MARK: - SwipeCardStack

extension GameViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        viewModel.cardModels.count
    }
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return configureCard()
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        didSwipeCard.send()
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        guard !viewModel.cardIsOpen else { return }
        guard let card = cardStack.card(forIndexAt: index) else { return }
        UIView.transition(
            with: card,
            duration: Constants.durationOfAnimation,
            options: [.curveEaseOut, .transitionFlipFromRight],
            animations: {
                guard
                    let card = card.content as? CardView,
                    let model = self.viewModel.cardModels[safe: index]
                else { return }
                card.configure(with: model)
            },
            completion: nil
        )
        card.swipeDirections = SwipeDirection.allDirections
        tapCard.send()
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        didSwipeAllCards.send()
    }
    
    // MARK: - Private
    
    private func configureCard() -> SwipeCard {
        let card = SwipeCard()
        let cardView = CardView()
        card.swipeDirections = []
        card.content = cardView
        return card
    }
}
