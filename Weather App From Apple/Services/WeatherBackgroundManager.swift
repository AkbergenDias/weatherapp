//
//  WeatherBackgroundManager.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 09.05.2026.
//

import Foundation

struct WeatherBackgroundManager {
    
    enum TimeOfDay: String {
        case morning = "Morning"
        case day = "Day"
        case evening = "Evening"
        case night = "Night"
    }
    
    enum WeatherCondition: String {
        case clear = "Clear"
        case rainy = "Rainy"
    }

    static func getBackgroundImageName(for date: Date = Date(), conditionCode: String) -> String {
        let timeOfDay = getTimeOfDay(from: date)
        let weatherCondition = getWeatherCondition(from: conditionCode)
        
        return "\(weatherCondition.rawValue)\(timeOfDay.rawValue)Background"
    }
    
    private static func getTimeOfDay(from date: Date) -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 6..<12:
            return .morning
        case 12..<18:
            return .day
        case 18..<22:
            return .evening
        default:
            return .night
        }
    }
    
    private static func getWeatherCondition(from condition: String) -> WeatherCondition {
        let lowercased = condition.lowercased()
        if lowercased.contains("rain") || lowercased.contains("drizzle") || lowercased.contains("thunderstorm") {
            return .rainy
        }
        return .clear
    }
}
