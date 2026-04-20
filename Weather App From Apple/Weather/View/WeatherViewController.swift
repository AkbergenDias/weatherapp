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
    private let mainView = WeatherMainView()
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupBindings()
        mainView.refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        print("WeatherViewController загружен")
    }
    
    private func setupBackground() {
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            self?.mainView.updateState(state)
        }
    }
    
    @objc private func didPullToRefresh() {
        viewModel.refreshWeather()
        print("Обновление данных.....")
    }
}
