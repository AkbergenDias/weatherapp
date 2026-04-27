//
//  WeatherHourlySectionView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 20.04.2026.
//

import UIKit
import SnapKit

class WeatherHourlySectionView: UIView {
    
    private var hourlyItems: [HourlyWeather] = []
    
    // MARK: - UI elements
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.12)
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 50, height: 90)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(HourlyItemCell.self, forCellWithReuseIdentifier: "HourlyItemCell")
        return collectionView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        backgroundColor = .systemBlue.withAlphaComponent(0.52)
        layer.cornerRadius = 12
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.alwaysBounceHorizontal = true
        
        addSubview(titleLabel)
        addSubview(separatorView)
        addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(90)
        }
    }
    
    func configure(with items: [HourlyWeather], description: String) {
        self.titleLabel.text = description
        self.hourlyItems = items
        collectionView.reloadData()
    }
    

}

// MARK: - UICollectionViewDataSource
extension WeatherHourlySectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyItemCell", for: indexPath) as? HourlyItemCell else {
            return UICollectionViewCell()
        }
        
        let item = hourlyItems[indexPath.row]
        
        cell.configure(time: item.time, icon: item.icon, temp: item.temp, iconCode: item.iconCode)
        
        return cell
    }
}
