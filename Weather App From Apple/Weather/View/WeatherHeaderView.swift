//
//  WeatherHeaderView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 19.04.2026.
//

import UIKit
import SnapKit

class WeatherHeaderView: UIView {

    // MARK: - UI elements
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .medium)
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 92, weight: .thin)
        label.textAlignment = .center
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "C9FFFA") //TODO: Fix Black color
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var maxMinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        
        addSubview(cityLabel)
        addSubview(temperatureLabel)
        addSubview(descriptionLabel)
        addSubview(maxMinLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(-5)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(-5)
            make.centerX.equalToSuperview()
        }
        
        maxMinLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    func configure(city: String, temp: String, description: String, minMax: String) {
        cityLabel.text = city
        temperatureLabel.text = temp
        descriptionLabel.text = description.capitalized
        maxMinLabel.text = minMax
    }
}
