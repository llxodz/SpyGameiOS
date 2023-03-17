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
    func fetchCategories() -> AnyPublisher<NetworkState, Error>
}

// MARK: - NetworkRepository

final class NetworkRepository: INetworkRepository {
    
    // Dependencies
    private let service: NetworkService
    private var cancellables = Set<AnyCancellable>()
    private var networkStateSubject = PassthroughSubject<NetworkState, Error>()
    
    // MARK: - Init
    
    init(service: NetworkService = NetworkService(session: URLSession(configuration: .default))) {
        self.service = service
    }
    
    @discardableResult
    func fetchCategories() -> AnyPublisher<NetworkState, Error> {
        networkStateSubject.send(.loading)
        
        let resource = Resource<GamingCategory>(url: SpyEndpoint.allCategories.url)
        service
            .load(resource)
            .sink { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error):
                    self?.networkStateSubject.send(.failed(error))
                }
            } receiveValue: { [weak self] response in
                self?.networkStateSubject.send(.success(response))
            }
            .store(in: &cancellables)
        return networkStateSubject.eraseToAnyPublisher()
    }
}
