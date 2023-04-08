//
//  NetworkRepository.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 14.03.2023.
//

import Foundation
import Combine

// MARK: - INetworkRepository

protocol INetworkRepository {
    
    @discardableResult
    func fetchCategories() -> AnyPublisher<CategoriesState, Never>
}

// MARK: - NetworkRepository

final class NetworkRepository: INetworkRepository {
    
    // Dependencies
    private let service: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(service: NetworkService = NetworkService(session: URLSession(configuration: .default))) {
        self.service = service
    }
    
    @discardableResult
    func fetchCategories() -> AnyPublisher<CategoriesState, Never> {
        let categoriesState = CurrentValueSubject<CategoriesState, Never>(.loading)
        let resource = Resource<[GameCategoryData]>(url: SpyEndpoint.allCategories.url)
        service
            .load(resource)
            .sink { result in
                switch result {
                case .finished: break
                case .failure(_):
                    categoriesState.send(.failed)
                }
            } receiveValue: { response in
                categoriesState.send(.success(response))
            }
            .store(in: &cancellables)
        return categoriesState.eraseToAnyPublisher()
    }
}
