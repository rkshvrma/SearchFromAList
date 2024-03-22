//
//  CountriesViewController.swift
//  SearchFromAListOfCountries
//
//  Created by rakesh on 3/19/24.
//

import UIKit
import Combine

class CountriesViewController: UIViewController {

    private let viewModel: CountriesViewModeling
    private var subscribers = Set<AnyCancellable>()
    
    private lazy var countryTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(CountryViewCell.self, forCellReuseIdentifier: CountryViewCell.reuseId)
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.placeholder = "Search Countries by Name or Capital"
        navigationItem.searchController = controller
        return controller
    }()
    
    init(viewModel: CountriesViewModeling = CountriesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        requestCountries()
    }
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        title = "Countries"
        _ = searchController
        
        view.addSubview(countryTableView)
        countryTableView.bindToSuperView()
    }
    
    private func requestCountries() {
        viewModel.countries
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.countryTableView.reloadData()
            }
            .store(in: &subscribers)
        
        viewModel.requestCountries()
    }
}

extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryViewCell.reuseId, for: indexPath) as? CountryViewCell else {
            return UITableViewCell()
        }
        cell.update(with: viewModel, index: indexPath.row)
        return cell
    }
}

extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterCountries(by: searchText)
    }
}
