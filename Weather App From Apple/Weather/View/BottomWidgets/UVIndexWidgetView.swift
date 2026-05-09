//
//  UVIndexWidgetView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 09.05.2026.
//

import UIKit
import SnapKit

class UVIndexWidgetView: WeatherBaseWidgetView {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let gradientBar: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.clipsToBounds = false
        return view
    }()
    
    private let dotIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private var progress: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient()
        updateIndicatorPosition()
    }
    
    private func setupLayout() {
        containerView.addSubview(valueLabel)
        containerView.addSubview(levelLabel)
        containerView.addSubview(gradientBar)
        gradientBar.addSubview(dotIndicator)
        containerView.addSubview(descLabel)
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().inset(12)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(12)
        }
        
        gradientBar.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(4)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(gradientBar.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func applyGradient() {
        gradientBar.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        gradient.frame = gradientBar.bounds
        gradient.colors = [
            UIColor.systemGreen.cgColor,
            UIColor.systemYellow.cgColor,
            UIColor.systemOrange.cgColor,
            UIColor.systemRed.cgColor,
            UIColor.systemPurple.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.cornerRadius = 2
        gradientBar.layer.insertSublayer(gradient, at: 0)
    }
    
    private func updateIndicatorPosition() {
        let barWidth = gradientBar.bounds.width
        let indicatorWidth: CGFloat = 6
        let xPosition = (barWidth - indicatorWidth) * progress
        dotIndicator.frame = CGRect(x: xPosition, y: -1, width: indicatorWidth, height: indicatorWidth)
    }
    
    func configure(value: String, level: String, desc: String, progress: CGFloat) {
        setBaseInfo(title: "УФ-ИНДЕКС", icon: "sun.max.fill")
        valueLabel.text = value
        levelLabel.text = level
        descLabel.text = desc
        self.progress = max(0.0, min(1.0, progress))
        setNeedsLayout()
    }
}
