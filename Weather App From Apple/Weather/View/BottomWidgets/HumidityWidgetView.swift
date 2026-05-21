//
//  HumidityWidgetView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 09.05.2026.
//

import UIKit
import SnapKit

class HumidityWidgetView: WeatherBaseWidgetView {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupLayout() {
        containerView.addSubview(valueLabel)
        containerView.addSubview(bottomLabel)
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().inset(12)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(humidity: String, dewPointText: String) {
        setBaseInfo(title: "ВЛАЖНОСТЬ", icon: "humidity")
        valueLabel.text = humidity
        bottomLabel.text = dewPointText
    }
}
