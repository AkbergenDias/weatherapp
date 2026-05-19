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
    let onAvarageView = OnAvarageWidgetView()
    let feelsLikeView = FeelsLikeWidgetView()
    let windView = WeatherWindWidgetView()
    let uvIndexView = UVIndexWidgetView()
    let sunsetView = SunsetWidgetView()
    let humidityView = HumidityWidgetView()
    let pressureView = PressureWidgetView()
    let refreshControl = UIRefreshControl()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ClearDayBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var firstRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [onAvarageView, feelsLikeView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    private lazy var secondRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [uvIndexView, sunsetView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()

    private lazy var thirdRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [humidityView, pressureView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    private lazy var widgetsVerticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstRowStack, windView, secondRowStack, thirdRowStack])
        stack.axis = .vertical
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
        contentView.addSubview(widgetsVerticalStack)
        
        addSubview(activityIndicator)
        activityIndicator.color = .white
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        widgetsVerticalStack.snp.makeConstraints { make in
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
            widgetsVerticalStack.isHidden = true

        case .success(let model):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            headerView.isHidden = false
            weatherHourlySectionView.isHidden = false
            weatherDailySectionView.isHidden = false
            widgetsVerticalStack.isHidden = false
            backgroundImageView.isHidden = false
            
            backgroundImageView.image = UIImage(named: model.backgroundImageName) ?? UIImage(named: "ClearDayBackground")
            
            headerView.configure(
                city: model.cityName,
                temp: model.temperature,
                description: model.description,
                minMax: model.minMax
            )
            
            weatherHourlySectionView.configure(
                with: model.hourlyForecast,
                description: model.description
            )
            
            weatherDailySectionView.configure(
                with: model.dailyForecast
            )
            
            onAvarageView.configure(
                diff: model.averageDiff,
                desc: model.averageDesc,
                todayMax: model.todayMax,
                avgMax: model.averageMax
            )
            
            feelsLikeView.configure(
                temp: model.feelsLike,
                desc: "По ощущениям примерно так же, как фактическая температура."
            )
            
            windView.configure(
                speed: model.windSpeed,
                gusts: model.windGusts,
                direction: model.windDirection
            )
            
            uvIndexView.configure(
                value: model.uvValue,
                level: model.uvLevel,
                desc: model.uvDesc,
                progress: model.uvProgress
            )
            
            sunsetView.configure(
                isSunset: model.isSunsetMain,
                mainTime: model.mainSunTime,
                subText: model.subSunTimeText
            )
            
            humidityView.configure(
                humidity: model.humidityValue,
                dewPointText: model.dewPointText
            )
            
            pressureView.configure(
                pressure: model.pressureValue,
                subText: model.pressureSubText
            )

            
        case .error(let message):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            print("Ошибка: \(message)")
        }
    }
    
    func playEntranceAnimation() {
        let sections: [UIView] = [widgetsVerticalStack, weatherDailySectionView, weatherDailySectionView, headerView]

        sections.enumerated().forEach { i, section in
            section.alpha = 0
            section.transform = CGAffineTransform(translationX: 0, y: 40)

            UIView.animate(withDuration: 0.5,
                           delay: Double(i) * 0.08,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseOut) {
                section.alpha = 1
                section.transform = .identity
            }
        }
    }
}
