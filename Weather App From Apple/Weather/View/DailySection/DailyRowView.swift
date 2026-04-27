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
    
    lazy var tempBar: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        view.layer.cornerRadius = 2
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
        addSubview(tempBar)
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
        
        dayLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(76)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(dayLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        minTempLabel.snp.makeConstraints { make in
            make.right.equalTo(tempBar.snp.left).offset(-6)
            make.centerY.equalToSuperview()
            make.width.equalTo(32)
        }
        
        tempBar.snp.makeConstraints { make in
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
    
    func configure(day: String, icon: UIImage?, min: String, max: String) {
        dayLabel.text = day
        iconImageView.image = icon
        minTempLabel.text = min
        maxTempLabel.text = max
    }
    
}
