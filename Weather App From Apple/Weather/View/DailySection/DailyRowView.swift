//
//  DailyRowView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 26.04.2026.
//

import UIKit

class DailyRowView: UIView {
    
    // MARK: - UI Components
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .right
        return label
    }()
    
    lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private let trackBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let gradientBar: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()
    
    private let dotIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.isHidden = true
        return view
    }()
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: SetupUI
    private func setupUI() {
        addSubview(dayLabel)
        addSubview(iconImageView)
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
        addSubview(trackBar)
        trackBar.addSubview(gradientBar)
        trackBar.addSubview(dotIndicator)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(76)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(dayLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        minTempLabel.snp.makeConstraints { make in
            make.right.equalTo(trackBar.snp.left).offset(-6)
            make.centerY.equalToSuperview()
            make.width.equalTo(32)
        }
        
        trackBar.snp.makeConstraints { make in
            make.right.equalTo(maxTempLabel.snp.left).offset(-6)
            make.centerY.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(94)
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.width.equalTo(32)
        }
    
    }
    
    func configure(with model: DailyWeather) {
        dayLabel.text = model.day
        iconImageView.image = model.icon
        minTempLabel.text = "\(model.minTemp)°"
        maxTempLabel.text = "\(model.maxTemp)°"
        
        let totalRange = CGFloat(model.maxTempWeek - model.minTempWeek)
        guard totalRange > 0 else { return }
        
        let startPercent = CGFloat(model.minTemp - model.minTempWeek) / totalRange
        let endPercent = CGFloat(model.maxTemp - model.minTempWeek) / totalRange
        
        gradientBar.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(80 * startPercent)
            make.trailing.equalToSuperview().offset(-(80 * (1 - endPercent)))
        }
        
        applyGradient()
        
        if let current = model.currentTemp {
            dotIndicator.isHidden = false
            let currentPercent = CGFloat(current - model.minTempWeek) / totalRange
            dotIndicator.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalTo(trackBar.snp.leading).offset(80 * currentPercent)
                make.size.equalTo(4)
            }
        } else {
            dotIndicator.isHidden = true
        }
    }
    
    private func applyGradient() {
        gradientBar.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 80, height: 4) // Ширина шкалы
        gradient.colors = [UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradientBar.layer.insertSublayer(gradient, at: 0)
    }
    
}
