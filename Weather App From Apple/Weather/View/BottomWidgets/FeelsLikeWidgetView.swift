//
//  FeelsLikeWidgetView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 09.05.2026.
//

import SnapKit
import UIKit

class FeelsLikeWidgetView: WeatherBaseWidgetView {
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomContent()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupCustomContent() {
        containerView.addSubview(tempLabel)
        containerView.addSubview(descriptionLabel)
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(temp: String, desc: String) {
        setBaseInfo(title: "Ощущается как", icon: "thermometer.medium")
        tempLabel.text = temp
        descriptionLabel.text = desc
    }
}
