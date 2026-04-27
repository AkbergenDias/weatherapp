//
//  WeatherIconManager.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 25.04.2026.
//
import UIKit

enum WeatherIconManager {
    static func getIcon(for code: String) -> UIImage? {
        switch code {
        case "01d": return UIImage(named: "sun")
        case "01n": return UIImage(named: "moon")
        case "02d", "03d", "04d", "02n", "03n", "04n": return UIImage(named: "cloud")
        case "09d", "10d", "11d", "09n", "10n", "11n": return UIImage(named: "rain")
        case "50d", "50n": return UIImage(named: "wind")
        default: return UIImage(named: "cloud")
        }
    }
}
