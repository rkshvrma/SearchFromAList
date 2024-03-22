//
//  Environment.swift
//  SearchFromAListOfCountries
//
//  Created by rakesh on 3/19/24.
//

import Foundation

enum Environment {
    case countries
    
    var request: URLRequest? {
        guard let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json") else { return nil }
        return URLRequest(url: url)
    }
}
