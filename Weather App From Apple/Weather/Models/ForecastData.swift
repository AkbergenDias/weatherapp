//
//  ForecastData.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 25.04.2026.
//

import Foundation

struct ForecastData: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}
