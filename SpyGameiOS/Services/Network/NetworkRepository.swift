//
//  NetworkRepository.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 14.03.2023.
//

import UIKit
import Combine

final class NetworkRepository: BaseRepository {
    
    private let service: NetworkService
    private var cancellables = Set<AnyCancellable>()
    private var subject = PassthroughSubject<NetworkState, Error>()
    
    @Published private var data: Categories?
    
    init(service: NetworkService = NetworkService(session: URLSession(configuration: .default))) {
        self.service = service
    }
    
    @discardableResult
    func fetchCategories() -> AnyPublisher<NetworkState, Error> {
        subject.send(.loading)
        
        let resource = Resource<Categories>(url: SpyEndpoint.fetchCategories.url)
        service
            .load(resource)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .finished: break
                case .failure(let error):
                    self.subject.send(.failed(error))
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.subject.send(.success(response))
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
}
