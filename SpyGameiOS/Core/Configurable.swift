//
//  Configurable.swift
//  SpyGameiOS
//
//  Created by Andrew Firsenko on 13.01.2022.
//

import Foundation

public protocol Configurable: AnyObject {
    
    associatedtype Model
    
    func configure(with model: Model)
}
