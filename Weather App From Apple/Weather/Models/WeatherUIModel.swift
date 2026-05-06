//
//  WeatherUIModel.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 19.04.2026.
//

import Foundation
import UIKit

struct WeatherUIModel {
    let cityName: String
    let temperature: String
    let description: String
    let summary: String
    let minMax: String
    let hourlyForecast: [HourlyWeather]
    let dailyForecast: [DailyWeather]
    let feelsLike: String
    let uvIndex: String
}

struct HourlyWeather {
    let time: String
    let icon: UIImage
    let temp: String
    let iconCode: String
}

struct DailyWeather {
    let day: String
    let icon: UIImage
    let minTemp: String
    let maxTemp: String
}
