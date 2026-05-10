//
//  WeatherTabBarView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 10.05.2026.
//

import UIKit
import SnapKit

class WeatherTabBarView: UIView {
    
    weak var delegate: WeatherTabBarDelegate?
    
    // MARK: - UI Components
    
    lazy var leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "tabLeft"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(leftTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var centerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "tabCenter"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(centerTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "tabRight"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(rightTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(leftButton)
        addSubview(centerButton)
        addSubview(rightButton)
        
        centerButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(44)
        }
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(centerButton.snp.leading).offset(-80)
            make.size.equalTo(44)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(centerButton.snp.trailing).offset(80)
            make.size.equalTo(44)
        }
    }
    
    private func setupGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp))
        swipeUp.direction = .up
        self.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        centerButton.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        centerButton.addGestureRecognizer(swipeRight)
    }
    
    // MARK: - Actions
    @objc private func leftTapped() {
        delegate?.tabBarDidTapLeft()
    }
    
    @objc private func centerTapped() {
        delegate?.tabBarDidTapCenter()
    }
    
    @objc private func rightTapped() {
        delegate?.tabBarDidTapRight()
    }
    
    @objc private func handleSwipeUp() {
        delegate?.tabBarDidSwipeUp()
    }
    
    @objc private func handleSwipeLeft() {
        delegate?.tabBarDidSwipeLeft()
    }
    
    @objc private func handleSwipeRight() {
        delegate?.tabBarDidSwipeRight()
    }
}
