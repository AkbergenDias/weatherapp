//
//  WeatherIconManager.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 25.04.2026.
//
import UIKit

enum WeatherIconManager {
    static func getIcon(for code: String) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let systemName: String
        var iconColor: UIColor = .white
        
        switch code {
        case "01d": systemName = "sun.max.fill"
            iconColor = .systemYellow
        case "01n": systemName = "moon.stars.fill"
        case "02d", "02n": systemName = "cloud.sun.fill"
        case "09d", "10d": systemName = "cloud.rain.fill"
        default: systemName = "cloud.fill"
        }
        
        return UIImage(systemName: systemName, withConfiguration: config)?.withTintColor(iconColor, renderingMode: .alwaysOriginal)
    }
}
