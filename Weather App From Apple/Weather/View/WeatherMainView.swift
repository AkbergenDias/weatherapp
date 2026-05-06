//
//  WeatherMainView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 19.04.2026.
//

import UIKit

class WeatherMainView: UIView {
    
    let headerView = WeatherHeaderView()
    let weatherHourlySectionView = WeatherHourlySectionView()
    let weatherDailySectionView = WeatherDailySectionView()
    let feelsLikeView = WeatherDetailSquareView()
    let uvIndexView = WeatherDetailSquareView()
    let refreshControl = UIRefreshControl()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SunnyBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var firstRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [feelsLikeView, uvIndexView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(backgroundImageView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        
        contentView.addSubview(headerView)
        contentView.addSubview(weatherHourlySectionView)
        contentView.addSubview(weatherDailySectionView)
        contentView.addSubview(firstRowStack)
        
        addSubview(activityIndicator)
        activityIndicator.color = .white
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        weatherHourlySectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(76)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        weatherDailySectionView.snp.makeConstraints { make in
            make.top.equalTo(weatherHourlySectionView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        firstRowStack.snp.makeConstraints { make in
            make.top.equalTo(weatherDailySectionView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func updateState(_ state: WeatherState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            headerView.isHidden = true
            weatherHourlySectionView.isHidden = true
            weatherDailySectionView.isHidden = true
            firstRowStack.isHidden = true
            
        case .success(let model):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            headerView.isHidden = false
            weatherHourlySectionView.isHidden = false
            weatherDailySectionView.isHidden = false
            firstRowStack.isHidden = false
            
            headerView.configure(city: model.cityName, temp: model.temperature, description: model.description, minMax: model.minMax)
            weatherHourlySectionView.configure(with: model.hourlyForecast, description: model.description)
            weatherDailySectionView.configure(with: model.dailyForecast)
            
            
        case .error(let message):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            print("Ошибка: \(message)")
        }
    }
}
