//
//  WindWidgetView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 09.05.2026.
//

import UIKit
import SnapKit

class WeatherWindWidgetView: UIView {
    
    // MARK: - UI Elements
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "wind")
        iv.tintColor = .white.withAlphaComponent(0.5)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ВЕТЕР"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }()
    
    private let windSpeedRow = WeatherWindRowView(title: "Ветер")
    private let gustsRow = WeatherWindRowView(title: "Порывы ветра")
    private let directionRow = WeatherWindRowView(title: "Направление")
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [windSpeedRow, gustsRow, directionRow])
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        addSubview(blurView)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let content = blurView.contentView
        content.addSubview(iconView)
        content.addSubview(titleLabel)
        content.addSubview(mainStackView)
        
        iconView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(6)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(speed: String, gusts: String, direction: String) {
        windSpeedRow.setValue(speed)
        gustsRow.setValue(gusts)
        directionRow.setValue(direction)
    }
}

// MARK: - WeatherWindRowView
private class WeatherWindRowView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .right
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.15)
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(separator)
        

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setValue(_ text: String) {
        valueLabel.text = text
    }
}
