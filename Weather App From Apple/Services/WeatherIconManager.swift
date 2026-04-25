//
//  WeatherIconManager.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 25.04.2026.
//

enum WeatherIconManager {
    static func getIcon(for code: String) -> String {
        switch code {
        case "01d": return "sun.fill"
        case "01n": return "moon.fill"
        case "02d", "03d", "04d", "02n", "03n", "04n": return "cloud.fill"
        case "09d", "10d", "11d", "09n", "10n", "11n": return "rain.fill"
        case "50d", "50n": return "wind"
        default: return "cloud.fill"
        }
    }
}
