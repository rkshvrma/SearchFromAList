//
//  CountryViewCell.swift
//  SearchFromAListOfCountries
//
//  Created by rakesh on 3/19/24.
//

import UIKit

class CountryViewCell: UITableViewCell {

    static let reuseId = "\(CountryViewCell.self)"

    private lazy var nameTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var codeTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private lazy var capitalTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        let mainStackView = UIStackView(frame: .zero)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        
        let nameStackView = UIStackView(frame: .zero)
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.axis = .horizontal
        
        nameStackView.addArrangedSubview(nameTextLabel)
        nameStackView.addArrangedSubview(UIView.createBufferView())
        nameStackView.addArrangedSubview(codeTextLabel)
        
        mainStackView.addArrangedSubview(nameStackView)
        mainStackView.addArrangedSubview(capitalTextLabel)
        
        contentView.addSubview(mainStackView)
        mainStackView.bindToSuperView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameTextLabel.text = ""
        codeTextLabel.text = ""
        capitalTextLabel.text = ""
    }
    
    func update(with viewModel: CountriesViewModelDataSource, index: Int) {
        nameTextLabel.text = "\(viewModel.name(for: index)), \(viewModel.region(for: index))"
        codeTextLabel.text = viewModel.code(for: index)
        capitalTextLabel.text = viewModel.capital(for: index)
    }
}
