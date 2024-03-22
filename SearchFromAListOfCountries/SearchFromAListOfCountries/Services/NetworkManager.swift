//
//  NetworkManager.swift
//  SearchFromAListOfCountries
//
//  Created by rakesh on 3/19/24.
//

import Foundation
import Combine

protocol NetworkManaging {
    func fetchModel<T: Decodable>(for request: URLRequest?) -> AnyPublisher<T, NetworkError>
}

class NetworkManager {
    let session: URLSession
    let decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
}

extension NetworkManager: NetworkManaging {
    func fetchModel<T: Decodable>(for request: URLRequest?) -> AnyPublisher<T, NetworkError> {
        guard let request = request else {
            return Fail(error: NetworkError.badRequest).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { map in
                if let httpResponse = map.response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                    throw NetworkError.badStatusCode(httpResponse.statusCode)
                }
                return map.data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if let decodeError = error as? DecodingError {
                    return NetworkError.decodingError(decodeError)
                }
                return NetworkError.serverError(error)
            }
            .eraseToAnyPublisher()
    }
}
