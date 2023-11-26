//
//  BaseViewModel.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 12.03.2023.
//

import Foundation

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    /// Трансформирует Input в Output
    func transform(input: Input) -> Output
}
