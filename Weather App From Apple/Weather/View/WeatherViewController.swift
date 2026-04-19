//
//  ViewController.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import UIKit
import SnapKit

class WeatherViewController: UIViewController {
    
    private let viewModel: WeatherViewModel
    private let gradientLayer = GradientManager.getGradient(for: .evening)
    let headerView = WeatherHeaderView()
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        print("WeatherViewController загружен")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setupUI() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(89)
        }
    }
    
    private func setupBindings() {
        
        viewModel.onDataUpdate = {[weak self] uiModel in
            self?.headerView.configure(city: uiModel.cityName, temp: uiModel.temperature, description: uiModel.description, minMax: uiModel.minMax)
        }
    }
}
