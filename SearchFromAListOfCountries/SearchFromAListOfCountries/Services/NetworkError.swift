//
//  NetworkError.swift
//  SearchFromAListOfCountries
//
//  Created by rakesh on 3/19/24.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case badStatusCode(_ code: Int)
    case decodingError(_ error: DecodingError)
    case serverError(_ error: Error)
}
