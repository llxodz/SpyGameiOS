//
//  NetworkService.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 13.03.2023.
//

import Foundation
import Combine

// MARK: - INetworkService

protocol INetworkService {
    
    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error>
}

// MARK: - NetworkService

final class NetworkService: INetworkService {
    
    private let session: URLSession

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        guard let request = resource.request else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.invalidRequest }
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }
                guard 200..<300 ~= response.statusCode else {
                    return Fail(error: NetworkError.dataLoadingError(statusCode: response.statusCode, data: data)).eraseToAnyPublisher()
                }
                return Just(data)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in NetworkError.jsonDecodingError(error: error) }
            .eraseToAnyPublisher()
    }
}
