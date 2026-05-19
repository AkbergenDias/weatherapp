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
    private let cityIndex: Int
    private var hasAnimatedEntrance = false
    
    private let gradientLayer = GradientManager.getGradient(for: .current())
    private let mainView = WeatherMainView()
    private let tabBarView = WeatherTabBarView()
    
    init(cityIndex: Int, viewModel: WeatherViewModel) {
        self.cityIndex = cityIndex
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
        print("WeatherViewController для города с индексом \(cityIndex) загружен")
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
        if let state = viewModel.getState(for: cityIndex) {
            mainView.updateState(state)
        }

        viewModel.stateCallbacks[cityIndex] = { [weak self] state in
            guard let self else { return }
            DispatchQueue.main.async {
                self.mainView.updateState(state)
                if case .success = state, !self.hasAnimatedEntrance {
                    self.hasAnimatedEntrance = true
                    self.mainView.playEntranceAnimation()
                }
                switch state {
                case .success, .error:
                    self.mainView.refreshControl.endRefreshing()
                case .loading:
                    break
                }
            }
        }
    }
    
    @objc private func didPullToRefresh() {
        viewModel.refreshWeather(for: cityIndex)
    }
    
    deinit {
        viewModel.stateCallbacks[cityIndex] = nil
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
        (parent as? WeatherPageViewController)?.openSavedCitiesList()
    }
    
    func tabBarDidSwipeUp() {
        (parent as? WeatherPageViewController)?.openSavedCitiesList()
    }
    
    func tabBarDidSwipeLeft() {
        print("Свайп влево: переключаем на следующий город")
        (parent as? WeatherPageViewController)?.movePage(direction: .next)
    }
    
    func tabBarDidSwipeRight() {
        print("Свайп вправо: переключаем на предыдущий город")
        (parent as? WeatherPageViewController)?.movePage(direction: .previous)
    }
}
