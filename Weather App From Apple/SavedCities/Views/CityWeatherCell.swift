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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
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
    }
    
    func showLocationIcon() {
        locationIcon.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        locationIcon.isHidden = true
    }
}
