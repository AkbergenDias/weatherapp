//
//  WeatherDailySectionView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 20.04.2026.
//

import UIKit

class WeatherDailySectionView: UIView {
    
    // MARK: - UI Components
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterialLight)
        let view = UIVisualEffectView(effect: blur)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
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
        addSubview(blurView)
        blurView.contentView.addSubview(titleLabel)
        blurView.contentView.addSubview(separatorView)
        blurView.contentView.addSubview(verticalStack)
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
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
