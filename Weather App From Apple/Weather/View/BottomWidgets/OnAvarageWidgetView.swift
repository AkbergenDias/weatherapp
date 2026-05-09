//
//  OnAvarageWidgetView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 09.05.2026.
//

import UIKit
import SnapKit

class OnAvarageWidgetView: WeatherBaseWidgetView {
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.15)
        return view
    }()
    
    private let todayTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сегодня H"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()
    
    private let todayValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let averageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "В среднем H"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()
    
    private let averageValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
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
        containerView.addSubview(separatorView)
        containerView.addSubview(todayTitleLabel)
        containerView.addSubview(todayValueLabel)
        containerView.addSubview(averageTitleLabel)
        containerView.addSubview(averageValueLabel)
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(1)
        }
        
        todayTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(todayValueLabel.snp.top).offset(-2)
            make.leading.equalToSuperview().inset(12)
        }
        
        todayValueLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(12)
        }
        
        averageTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(averageValueLabel.snp.top).offset(-2)
            make.trailing.equalToSuperview().inset(12)
        }
        
        averageValueLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configure(diff: String, desc: String, todayMax: String, avgMax: String) {
        setBaseInfo(title: "В среднем", icon: "chart.line.uptrend.xyaxis")
        tempLabel.text = diff
        descriptionLabel.text = desc
        todayValueLabel.text = todayMax
        averageValueLabel.text = avgMax
    }
}
