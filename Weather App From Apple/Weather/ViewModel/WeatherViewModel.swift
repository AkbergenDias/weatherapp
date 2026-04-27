//
//  WeatherViewModel.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//
import Foundation
import UIKit

enum WeatherState {
    case loading
    case success(WeatherUIModel)
    case error(String)
}

class WeatherViewModel: LocationManagerDelegate {
    var onStateChange: ((WeatherState) -> Void)?
    
    private let networkService: NetworkServiceProtocol
    private var locationManager: LocationManagerProtocol
    
    init(networkService: NetworkServiceProtocol, locationManager: LocationManagerProtocol) {
        self.networkService = networkService
        self.locationManager = locationManager
        self.locationManager.delegate = self
        
        locationManager.requestLocation()
    }
    
    func didUpdateLocation(lat: Double, lon: Double) {
        onStateChange?(.loading)
        print("Координаты получены: \(lat), \(lon)")
        
        //API оставил для домашки без git ignore
        let apiKey = "6dc2788ca091c6b2364a1891d83f95f4"
        let weatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")!
        let forecastUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")!
        
        Task {
            do {
                async let weatherFetch: WeatherData = try await networkService.fetch(url: weatherUrl)
                async let forecastFetch: ForecastResponse = try await networkService.fetch(url: forecastUrl)
                
                let (weatherData, forecastData) = try await (weatherFetch, forecastFetch)
                
                let hourlyModels = mapToHourly(forecastData)
                let dailyModels = mapToDaily(forecastData)
                
                let uiModel = WeatherUIModel(
                    cityName: weatherData.name,
                    temperature: "\(Int(weatherData.main.temp))°",
                    description: weatherData.weather.first?.description.capitalized ?? "",
                    summary: "Ветер: \(Int(weatherData.wind.speed)) км/ч",
                    minMax: "Макс: \(Int(weatherData.main.tempMax))° Мин: \(Int(weatherData.main.tempMin))°",
                    hourlyForecast: hourlyModels,
                    dailyForecast: dailyModels
                )
                
                await MainActor.run {
                    self.onStateChange?(.success(uiModel))
                }
            } catch {
                await MainActor.run { self.onStateChange?(.error(error.localizedDescription)) }
            }
        }
    }
        
    private func mapToUIModel(_ weatherData: WeatherData, hourlyModels: [HourlyWeather], dailyModels: [DailyWeather]) -> WeatherUIModel {
        
        let currentTemp = "\(Int(weatherData.main.temp))°"
        
        let max = Int(weatherData.main.tempMax)
        let min = Int(weatherData.main.tempMin)
        
        return WeatherUIModel(
            cityName: weatherData.name,
            temperature: currentTemp,
            description: weatherData.weather.first?.description.capitalized ?? "",
            summary: "Ветер: \(Int(weatherData.wind.speed)) км/ч",
            minMax: "Макс: \(max)°  Мин: \(min)°",
            hourlyForecast: hourlyModels,
            dailyForecast: dailyModels
        )
    }
    private func mapToHourly(_ data: ForecastResponse) -> [HourlyWeather] {
        return data.list.prefix(8).map { item in
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            
            let iconCode = item.weather.first?.icon ?? ""
            return HourlyWeather(
                time: formatter.string(from: date),
                icon: WeatherIconManager.getIcon(for: iconCode) ?? UIImage(),
                temp: "\(Int(item.main.temp))°",
                iconCode: iconCode
            )
        }
    }
        
    private func mapToDaily(_ data: ForecastResponse) -> [DailyWeather] {
        var dailyItems: [ForecastItem] = []
            
        for i in stride(from: 0, to: data.list.count, by: 8) {
            dailyItems.append(data.list[i])
        }
        
        return dailyItems.prefix(5).map { item in
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = Calendar.current.isDateInToday(date) ? "'Сегодня'" : "EEEE"
            
            let iconCode = item.weather.first?.icon ?? ""
            return DailyWeather(
                day: formatter.string(from: date).capitalized,
                icon: WeatherIconManager.getIcon(for: iconCode) ?? UIImage(),
                minTemp: "\(Int(item.main.tempMin))°",
                maxTemp: "\(Int(item.main.tempMax))°"
            )
        }
    }
    
    func didFailWithError(error: Error) {
        print("Ошибка геолокации: \(error.localizedDescription)")
    }
    
    func refreshWeather(){
        locationManager.requestLocation()
    }
}
