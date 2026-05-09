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
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
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
        stack.spacing = 0
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        
        addSubview(blurView)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let content = blurView.contentView
        
        content.addSubview(iconImage)
        content.addSubview(titleLabel)
        content.addSubview(separatorView)
        content.addSubview(verticalStack)
        
        iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImage)
            make.leading.equalTo(iconImage.snp.trailing).offset(6)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with days: [DailyWeather]) {
        verticalStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, dayData) in days.enumerated() {
            let row = DailyRowView()
            row.configure(with: dayData)
            verticalStack.addArrangedSubview(row)
            
            if index < days.count - 1 {
                let separator = createSeparator()
                verticalStack.addArrangedSubview(separator)
                
                separator.snp.makeConstraints { make in
                    make.height.equalTo(1)
                }
            }
        }
    }
    
    private func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.12)
        return view
    }
}
