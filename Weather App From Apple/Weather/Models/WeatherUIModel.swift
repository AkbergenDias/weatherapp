//
//  WeatherUIModel.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 19.04.2026.
//

import Foundation

struct WeatherUIModel {
    let cityName: String
    let temperature: String
    let description: String
    let summary: String
    let minMax: String
    let hourlyForecast: [HourlyWeather]
}
