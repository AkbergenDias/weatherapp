//
//  SavedCitiesViewController.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 10.05.2026.
//

import UIKit
import SnapKit
import MapKit

protocol SavedCitiesViewControllerDelegate: AnyObject {
    func didSelectCity(at index: Int)
    func didAddNewCity(_ cityName: String)
}

class SavedCitiesViewController: UIViewController {
    
    weak var delegate: SavedCitiesViewControllerDelegate?
    
    let viewModel = SavedCitiesViewModel()
    private var searchResults: [MKLocalSearchCompletion] = []
    private var isSearching = false
    var weatherStateProvider: ((Int) -> WeatherState?)?
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Погода"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let searchField = SearchTextField()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(CityWeatherCell.self, forCellReuseIdentifier: "CityWeatherCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColorManager.mainBackground
        
        setupUI()
        setupBindings()
        
        searchField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        searchField.onClearTapped = { [weak self] in
            self?.searchTextChanged()
        }
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(tableView)
        view.addSubview(statusLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }
    }
    
    @objc private func searchTextChanged() {
        viewModel.processSearchInput(searchField.text ?? "")
    }
    
}

// MARK: - Bindings
extension SavedCitiesViewController {
    private func setupBindings() {
        viewModel.onSavedCitiesUpdate = { [weak self] in
            DispatchQueue.main.async {
                if !(self?.isSearching ?? false) {
                    self?.tableView.reloadData()
                }
            }
        }
        
        viewModel.onSearchStateChange = { [weak self] state in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch state {
                case .empty:
                    self.isSearching = false
                    self.statusLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    
                case .searching:
                    self.isSearching = true
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "Идёт поиск..."
                    self.tableView.isHidden = true
                    
                case .results(let completions):
                    self.isSearching = true
                    self.statusLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.searchResults = completions
                    self.tableView.reloadData()
                    
                case .noResults:
                    self.isSearching = true
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "Ничего не найдено"
                    self.tableView.isHidden = true
                    
                case .error(let message):
                    self.isSearching = true
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "Ошибка: \(message)"
                    self.tableView.isHidden = true
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension SavedCitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchResults.count : viewModel.displayCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
            let completion = searchResults[indexPath.row]
            cell.textLabel?.text = completion.title + ", " + completion.subtitle
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherCell", for: indexPath) as? CityWeatherCell else {
                    return UITableViewCell()
                }
                let cityName = viewModel.displayCities[indexPath.row]
                let state = weatherStateProvider?(indexPath.row)
                cell.configure(cityName: cityName, weatherState: state, isCurrentLocation: indexPath.row == 0)
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isSearching ? 50 : 110
    }
    
    // MARK: - Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !isSearching, indexPath.row != 0 else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.viewModel.deleteCity(at: indexPath.row)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    // MARK: - City deselect
// MARK: - City deselect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isSearching {
            let selectedCompletion = searchResults[indexPath.row]
            
            viewModel.selectCompletion(selectedCompletion) { [weak self] coordinate, cityName in
                guard let self = self, let cityName = cityName else { return }
                
                self.viewModel.saveNewCity(cityName)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.searchField.text = ""
                    self.isSearching = false
                    
                    self.viewModel.loadSavedCities()
                    
                    self.delegate?.didAddNewCity(cityName)
                    self.dismiss(animated: true)
                }
            }
        } else {
            delegate?.didSelectCity(at: indexPath.row)
            dismiss(animated: true)
        }
    }
}
