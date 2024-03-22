//
//  CountriesViewModel.swift
//  SearchFromAListOfCountries
//
//  Created by rakesh on 3/19/24.
//

import Foundation
import Combine

typealias CountriesViewModeling = CountriesViewModelDelegate & CountriesViewModelDataSource

protocol CountriesViewModelDelegate {
    var countries: PassthroughSubject<[Country], Never> { get }
    func requestCountries()
    func filterCountries(by query: String)
}

protocol CountriesViewModelDataSource {
    var count: Int { get }
    func capital(for index: Int) -> String
    func code(for index: Int) -> String
    func name(for index: Int) -> String
    func region(for index: Int) -> String
}

class CountriesViewModel: CountriesViewModelDelegate {
    private var allCountries: [Country] = []
    private var filteredCountries: [Country] = [] {
        didSet {
            countries.send(filteredCountries)
        }
    }
    private let networkManager: NetworkManaging
    private var subscribers = Set<AnyCancellable>()
    
    var countries = PassthroughSubject<[Country], Never>()
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func requestCountries() {
        let request = Environment.countries.request
        networkManager.fetchModel(for: request)
            .sink { completion in
                switch completion {
                    // TODO: Consider handling error if occurs
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Closed Data Stream to fetch Countries")
                }
            } receiveValue: { [weak self] (countries: [Country]) in
                self?.allCountries = countries
                self?.filteredCountries = countries
            }
            .store(in: &subscribers)
    }
    
    func filterCountries(by query: String) {
        guard !query.isEmpty else {
            filteredCountries = allCountries
            return
        }
        let sanitizedQuery = sanitizeQuery(query: query)
        filteredCountries = allCountries.filter {
            $0.name.lowercased().contains(sanitizedQuery) || $0.capital.lowercased().contains(sanitizedQuery)
        }
    }
    
    private func sanitizeQuery(query: String) -> String {
        query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

extension CountriesViewModel: CountriesViewModelDataSource {
    var count: Int {
        filteredCountries.count
    }
    
    func capital(for index: Int) -> String {
        guard index < filteredCountries.count else { return Country.defaultValue }
        return filteredCountries[index].capital
    }
    
    func code(for index: Int) -> String {
        guard index < filteredCountries.count else { return Country.defaultValue }
        return filteredCountries[index].code
    }
    
    func name(for index: Int) -> String {
        guard index < filteredCountries.count else { return Country.defaultValue }
        return filteredCountries[index].name
    }
    
    func region(for index: Int) -> String {
        guard index < filteredCountries.count else { return Country.defaultValue }
        return filteredCountries[index].region
    }
}
