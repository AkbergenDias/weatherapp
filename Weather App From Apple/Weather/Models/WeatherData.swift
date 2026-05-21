//
//  WeatherData.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import Foundation

// MARK: Current Weather
struct WeatherData: Codable {
    let main: MainResponse
    let name: String
    let weather: [WeatherResponse]
    let wind: WindResponse
    let sys: SysResponse?
    let coord: Coordinates?
}

// MARK: 5-Day Forecast
struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: Int
    let main: MainResponse
    let weather: [WeatherResponse]
    let dt_txt: String? //dailty temp
}

// MARK: Shared
struct MainResponse: Codable {
    let temp: Double
    let humidity: Int
    let tempMax: Double
    let tempMin: Double
    let feelsLike: Double
    let pressure: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
        case tempMin = "temp_min" // Конверт из Snake_case в CamelCase
        case tempMax = "temp_max"
        case feelsLike = "feels_like"
        case pressure
    }
}

struct WeatherResponse: Codable {
    let description: String
    let icon: String
    let main: String
}

struct WindResponse: Codable {
    let speed: Double
    let deg: Int?
    let gust: Double?
}

struct UVResponse: Decodable {
    let value: Double
}

struct SysResponse: Codable {
    let sunrise: Int
    let sunset: Int
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}
