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
        let condition = getWeatherCondition(from: conditionCode)
        
        return "\(condition.rawValue)\(timeOfDay.rawValue)Background"
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
        let lower = condition.lowercased()
        if lower.contains("rain") || lower.contains("drizzle") || lower.contains("thunderstorm") || lower.contains("snow")
            || lower.hasPrefix("09") || lower.hasPrefix("10")
            || lower.hasPrefix("11") || lower.hasPrefix("13") {
            return .rainy
        }
        return .clear
    }
}
