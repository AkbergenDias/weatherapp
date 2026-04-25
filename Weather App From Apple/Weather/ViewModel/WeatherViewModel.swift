//
//  WeatherViewModel.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//
import Foundation

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
        
        let weatherUrlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        let forecastUrlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let weatherUrl = URL(string: weatherUrlString),
              let forecastUrl = URL(string: forecastUrlString) else { return }
        
        Task {
            do {
                async let fetchWeather: WeatherData = try await networkService.fetch(url: weatherUrl)
                async let fetchForecast: ForecastData = try await networkService.fetch(url: forecastUrl)
                
                let (weatherData, forecastData) = try await (fetchWeather, fetchForecast)
                
                
                let hourlyModels = mapToHourlyModel(forecastData)
                let summary = generateDescription(data: weatherData, forecast: forecastData)
                
                let uiModel = mapToUIModel(weatherData, hourlyModels: hourlyModels, summary: summary)
                
                await MainActor.run {
                    self.onStateChange?(.success(uiModel))
                }
                
            } catch {
                await MainActor.run {
                    self.onStateChange?(.error(error.localizedDescription))
                }
                print("Ошибка загрузки погоды: \(error)")
            }
        }
    }
    func didFailWithError(error: Error) {
            print("Ошибка геолокации: \(error.localizedDescription)")
    }
    
    private func mapToUIModel(_ data: WeatherData, hourlyModels: [HourlyWeather], summary: String) -> WeatherUIModel {
        let temp = "\(Int(data.main.temp))°"
        let max = Int(data.main.tempMax)
        let min = Int(data.main.tempMin)
        
        return WeatherUIModel(
            cityName: data.name,
            temperature: temp,
            description: data.weather.first?.description ?? "Нет данных",
            summary: summary,
            minMax: "Макс:\(max)°  Мин:\(min)°",
            hourlyForecast: hourlyModels
        )
    }
    
    func refreshWeather(){
        locationManager.requestLocation()
    }
    
    private func generateDescription(data: WeatherData, forecast: ForecastData) -> String {
        
        let windSpeed = Int(data.wind.speed * 3.6)
        let gustInfo = data.wind.gust != nil ? "Порывы до \(Int(data.wind.gust! * 3.6)) км/ч. " : ""
        let willBeSunny = forecast.list.prefix(4).allSatisfy { $0.weather.first?.main == "Clear" }
        let sunnyInfo = willBeSunny ? "Солнечно до конца дня." : "Ожидается облачность."
        
        return "\(gustInfo)\(sunnyInfo), Ветер:\(windSpeed)"
    }
    
    private func mapToHourlyModel(_ forecastData: ForecastData) -> [HourlyWeather] {
        let first24Hours = forecastData.list.prefix(8)
        
        return first24Hours.map { item in
            
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            let timeString = formatter.string(from: date)
            
            return HourlyWeather(
                time: timeString,
                icon: WeatherIconManager.getIcon(for: item.weather.first?.icon ?? ""),
                temp: "\(Int(item.main.temp))°"
            )
        }
    }
}
