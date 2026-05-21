//
//  HourlyItemView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 20.04.2026.
//

import UIKit
import SnapKit

class HourlyItemCell: UICollectionViewCell {
    
    static let initializer = "HourlyItemCell"
    
    //MARK: UI elements
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: SetupUI
    private func setupUI() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(iconImageView)
        
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(24)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(time: String, icon: UIImage?, temp: String, iconCode: String) {
        timeLabel.text = time
        iconImageView.image = icon
        temperatureLabel.text = temp
        
        if iconCode == "01d" {
            iconImageView.tintColor = .systemYellow
        } else {
            iconImageView.tintColor = .white
        }
    }


}
