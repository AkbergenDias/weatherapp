//
//  WeatherMainView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 19.04.2026.
//

import UIKit

class WeatherMainView: UIView {
    
    let headerView = WeatherHeaderView()
    let refreshControl = UIRefreshControl()
    
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        
        contentView.addSubview(headerView)
        addSubview(activityIndicator)
        activityIndicator.color = .white

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
            make.bottom.equalToSuperview().priority(.low)
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
        case .success(let model):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            headerView.isHidden = false
            headerView.configure(city: model.cityName, temp: model.temperature, description: model.description, minMax: model.minMax)
        case .error(let message):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            print("Ошибка: \(message)")
        }
    }
}
