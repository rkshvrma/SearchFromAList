//
//  Country.swift
//  SearchFromAListOfCountries
//
//  Created by rakesh on 3/19/24.
//

import Foundation

struct Country: Decodable {
    static let defaultValue = "N/A"
    
    let capital: String
    let code: String
    let name: String
    let region: String
}
