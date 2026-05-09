//
//  WeatherBaseWidgetView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 09.05.2026.
//

import UIKit
import SnapKit

class WeatherBaseWidgetView: UIView {
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white.withAlphaComponent(0.5)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }()
    
    let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupBaseUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupBaseUI() {
        addSubview(blurView)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width)
        }
        
        let content = blurView.contentView
        content.addSubview(iconView)
        content.addSubview(titleLabel)
        content.addSubview(containerView)
        
        iconView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(6)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func setBaseInfo(title: String, icon: String) {
        titleLabel.text = title.uppercased()
        iconView.image = UIImage(systemName: icon)
    }
}
