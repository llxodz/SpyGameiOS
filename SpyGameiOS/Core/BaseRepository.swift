//
//  BaseRepository.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 15.03.2023.
//

import Foundation
import Combine

public protocol BaseRepository {
    
    @discardableResult
    func fetchCategories() -> AnyPublisher<NetworkState, Error>
}
