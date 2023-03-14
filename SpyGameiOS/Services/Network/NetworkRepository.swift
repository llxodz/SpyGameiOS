//
//  NetworkRepository.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 14.03.2023.
//

import UIKit
import Combine

final class NetworkRepository {
    
    private let service: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: NetworkService = NetworkService(session: URLSession(configuration: .default))) {
        self.service = service
    }
    
    func loadData() {
        var data = ""
        let resource = Resource<DataModel>(url: URL(string: "https://aws.random.cat/meow")!)
        
        let cancellable = service
            .load(resource)
            .sink { result in
                switch result {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                data = response.file
            }
        self.cancellables.insert(cancellable)
        
        print(data)
    }
}

struct DataModel: Decodable {
    let file: String
}
