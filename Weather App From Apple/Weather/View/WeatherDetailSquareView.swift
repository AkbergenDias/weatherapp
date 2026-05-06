//
//  WeatherDetailSquareView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 04.05.2026.
//

import UIKit
import SnapKit

class WeatherDetailSquareView: UIView {
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white.withAlphaComponent(0.5)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        addSubview(blurView)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }

        self.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width)
        }
        
        let content = blurView.contentView
        content.addSubview(titleLabel)
        content.addSubview(iconView)
        content.addSubview(valueLabel)
        content.addSubview(descLabel)
        
        iconView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(6)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(12)
        }
        
        descLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    func configure(title: String, icon: String, value: String, desc: String) {
        titleLabel.text = title.uppercased()
        iconView.image = UIImage(systemName: icon)
        valueLabel.text = value
        descLabel.text = desc
    }
}
