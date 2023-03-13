//
//  NetworkError.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 13.03.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
}
