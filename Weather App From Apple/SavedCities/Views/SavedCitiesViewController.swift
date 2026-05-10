//
//  SavedCitiesViewController.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 10.05.2026.
//

import UIKit
import SnapKit

class SavedCitiesViewController: UIViewController {
    
    var savedCities: [String] = ["Алматы", "Астана", "Шымкент"]
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Погода"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Поиск города или аэропорта"
        bar.searchBarStyle = .minimal
        bar.searchTextField.textColor = .white
        bar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(CityWeatherCell.self, forCellReuseIdentifier: "CityWeatherCell")
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1, green: 0.18, blue: 0.28, alpha: 1.0)
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SavedCitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherCell", for: indexPath) as? CityWeatherCell else {
            return UITableViewCell()
        }
        let cityName = savedCities[indexPath.row]
        cell.configure(cityName: cityName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

// MARK: - Custom Cell for Cities
class CityWeatherCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.22, green: 0.44, blue: 0.69, alpha: 1.0).cgColor,
            UIColor(red: 0.15, green: 0.31, blue: 0.51, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "15:58"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "В основном облачно"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "11°"
        label.font = .systemFont(ofSize: 48, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private let minMaxLabel: UILabel = {
        let label = UILabel()
        label.text = "Макс.: 11°, мин.: 5°"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        containerView.addSubview(cityNameLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(weatherDescriptionLabel)
        containerView.addSubview(tempLabel)
        containerView.addSubview(minMaxLabel)
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(6)
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(16)
        }
        
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(16)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        minMaxLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(cityName: String) {
        cityNameLabel.text = cityName
    }
}
