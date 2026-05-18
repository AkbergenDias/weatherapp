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
    private let gradientLayer = GradientManager.getGradient(for: .current())
    private let mainView = WeatherMainView()
    private let tabBarView = WeatherTabBarView()
    
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
        setupMainUI()
        mainView.refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        print("WeatherViewController загружен")
    }
    
    private func setupMainUI() {
        view.addSubview(tabBarView)
        tabBarView.delegate = self
        
        tabBarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
            make.width.equalTo(280)
            make.height.equalTo(64)
        }
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

extension WeatherViewController: WeatherTabBarDelegate {
    
    func tabBarDidTapLeft() {
        print("Нажата левая кнопка (заглушка карты)")
    }
    
    func tabBarDidTapCenter() {
        print("Нажата центральная кнопка")
    }
    
    func tabBarDidTapRight() {
        openSavedCities()
    }
    
    func tabBarDidSwipeUp() {
        openSavedCities()
    }
    
    func tabBarDidSwipeLeft() {
        print("Свайп влево: переключаем на следующий город")
        viewModel.switchToNextCity()
    }
    
    func tabBarDidSwipeRight() {
        print("Свайп вправо: переключаем на предыдущий город")
        viewModel.switchToPreviousCity()
    }
    
    private func openSavedCities() {
        let savedCitiesVC = SavedCitiesViewController()
        savedCitiesVC.delegate = self
        savedCitiesVC.modalPresentationStyle = .pageSheet
        
        if let sheet = savedCitiesVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(savedCitiesVC, animated: true)
    }
}

extension WeatherViewController: SavedCitiesViewControllerDelegate {
    func didSelectCity(at index: Int) {
        viewModel.selectCity(at: index)
    }
}
