//
//  GameViewModel.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 05.04.2023.
//

import Foundation
import Combine

// MARK: - Input & Output

extension GameViewModel {
    
    struct Input {
        // Раскрытие карточки
        let tapCard: AnyPublisher<Void, Never>
        // Смахнули карточку
        let didSwipeCard: AnyPublisher<Void, Never>
        // didSwipeAllCards
        let didSwipeAllCards: AnyPublisher<Void, Never>
        // Старт игры
        let start: AnyPublisher<Void, Never>
    }
    
    struct Output {
        // все свайпнули
        let showStart: AnyPublisher<Void, Never>
        // Время (c)
        let updateTime: AnyPublisher<Int, Never>
    }
    
    // Initial model
    struct Model {
        let playersCount: Int
        let spiesCount: Int
        let minutesCount: Int
        let categories: [GameCategory]
    }
}

// MARK: - GameViewModel

final class GameViewModel: BaseViewModel {
    
    // Dependencies
    private let model: Model
    
    // Private property
    private let showStart = PassthroughSubject<Void, Never>()
    private let updateTime = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // Public property
    private(set) var cardIsOpen: Bool = false
    private(set) var cardModels: [CardView.Model] = []
    
    // MARK: - Init
    
    init(with model: Model) {
        self.model = model
        self.cardModels = generateCardModels()
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        input.tapCard
            .sink { [weak self] in
                self?.cardIsOpen = true
            }
            .store(in: &cancellables)
        input.didSwipeCard
            .sink { [weak self] in
                self?.cardIsOpen = false
            }
            .store(in: &cancellables)
        input.didSwipeAllCards
            .sink { [weak self] in
                guard let self = self else { return }
                self.updateTime.send(self.model.minutesCount)
                self.showStart.send()
            }
            .store(in: &cancellables)
        input.start
            .sink { [weak self] in
                // TODO: - Start timer
            }
            .store(in: &cancellables)
        return Output(
            showStart: showStart.eraseToAnyPublisher(),
            updateTime: updateTime.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Private
    
    private func generateCardModels() -> [CardView.Model] {
        let category = model.categories.randomElement()
        guard let location = category?.data.locations.randomElement() else { return [] }
        var models: [CardView.Model] = []
        for _ in 0..<model.spiesCount {
            models.append(CardView.Model(type: .spyPlayer, location: L10n.CardView.spyName))
        }
        for _ in 0..<(model.playersCount - model.spiesCount) {
            models.append(CardView.Model(type: .normalPlayer, location: location.name))
        }
        return models.shuffled()
    }
}