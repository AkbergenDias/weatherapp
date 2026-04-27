//
//  WeatherDailySectionView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 20.04.2026.
//

import UIKit

class WeatherDailySectionView: UIView {
    
    // MARK: - UI Components
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .white.withAlphaComponent(0.5)
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = .white.withAlphaComponent(0.5)
        titleLabel.text = "Прогноз на 10 дней"
        return titleLabel
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.12)
        return view
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        backgroundColor = .systemBlue.withAlphaComponent(0.52)
        layer.cornerRadius = 12

        addSubview(iconImage)
        addSubview(titleLabel)
        addSubview(separatorView)
        addSubview(verticalStack)
        
        iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalTo(iconImage.snp.right)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(with days: [DailyWeather]) {
        verticalStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        days.forEach { dayData in
            let row = DailyRowView()
            row.configure(
                day: dayData.day,
                icon: dayData.icon,
                min: dayData.minTemp,
                max: dayData.maxTemp
            )
            verticalStack.addArrangedSubview(row)
        }
    }
}
