//
//  WeatherData.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let name: String
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
    let tempMax: Double
    let tempMin: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
        case tempMin = "temp_min" // Конверт из Snake_case в CamelCase
        case tempMax = "temp_max"
    }
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let gust: Double?
}
