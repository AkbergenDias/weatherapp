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
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let icon: String
}
