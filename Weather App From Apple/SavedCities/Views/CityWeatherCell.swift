//
//  CityWeatherCell.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 13.05.2026.
//

import UIKit
import SnapKit

class CityWeatherCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()

    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let locationIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "location.fill"))
        icon.tintColor = .white
        icon.isHidden = true
        return icon
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
    
    private func setupUI() {
        contentView.addSubview(containerView)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(cityNameLabel)
        containerView.addSubview(locationIcon)
        containerView.addSubview(timeLabel)
        containerView.addSubview(weatherDescriptionLabel)
        containerView.addSubview(tempLabel)
        containerView.addSubview(minMaxLabel)
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(6)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        locationIcon.snp.makeConstraints { make in
            make.centerY.equalTo(cityNameLabel.snp.centerY)
            make.leading.equalTo(cityNameLabel.snp.trailing).offset(6)
            make.size.equalTo(14)
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
    
    func configure(cityName: String, weatherState: WeatherState?, isCurrentLocation: Bool) {
        cityNameLabel.text = cityName
        locationIcon.isHidden = !isCurrentLocation
        
        // Текущее время устройства (можно заменить на таймзону города при желании)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: Date())
        
        switch weatherState {
        case .loading:
            weatherDescriptionLabel.text = "Загрузка..."
            tempLabel.text = "--"
            minMaxLabel.text = ""
            backgroundImageView.isHidden = true
            
        case .success(let model):
            weatherDescriptionLabel.text = model.description
            tempLabel.text = model.temperature
            minMaxLabel.text = model.minMax
            
            if let backgroundImage = UIImage(named: model.backgroundImageName) {
                backgroundImageView.image = backgroundImage
                backgroundImageView.isHidden = false
            } else {
                backgroundImageView.isHidden = true
            }
            
        case .error(let message):
            weatherDescriptionLabel.text = "Ошибка"
            tempLabel.text = "!"
            minMaxLabel.text = message
            backgroundImageView.isHidden = true
            
        case .none:
            weatherDescriptionLabel.text = "Ожидание запроса..."
            tempLabel.text = "--"
            minMaxLabel.text = ""
            backgroundImageView.isHidden = true
        }
    }
    
    func showLocationIcon() {
        locationIcon.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        locationIcon.isHidden = true
        backgroundImageView.isHidden = true
        backgroundImageView.image = nil
    }
}
