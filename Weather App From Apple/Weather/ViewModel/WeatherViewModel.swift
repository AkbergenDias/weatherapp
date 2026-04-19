//
//  WeatherViewModel.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//
import Foundation

class WeatherViewModel: LocationManagerDelegate {
    var onDataUpdate: ((WeatherUIModel) -> Void)?
    var onError: ((String) -> Void)?
    
    private let networkService: NetworkServiceProtocol
    private var locationManager: LocationManagerProtocol
    
    init(networkService: NetworkServiceProtocol, locationManager: LocationManagerProtocol) {
        self.networkService = networkService
        self.locationManager = locationManager
        self.locationManager.delegate = self
        
        locationManager.requestLocation()
    }
    
    func didUpdateLocation(lat: Double, lon: Double) {
        print("Координаты получены: \(lat), \(lon)")
        //API оставил для домашки без git ignore
        let apiKey = "6dc2788ca091c6b2364a1891d83f95f4"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        Task {
            do {
                let weatherData: WeatherData = try await networkService.fetch(url: url)
                
                let uiModel = mapToUIModel(weatherData)
                
                await MainActor.run {
                    self.onDataUpdate?(uiModel)
                }
                
                print("Ответ от сервера")
                print("Город: \(weatherData.name)")
                print("Температура: \(weatherData.main.temp)°C")
                print("Описание: \(weatherData.weather.first?.description ?? "нет данных")")
                
            } catch {
                await MainActor.run {
                    self.onError?(error.localizedDescription)
                }
                print("Ошибка загрузки погоды: \(error)")
            }
        }
    }
    func didFailWithError(error: Error) {
            print("Ошибка геолокации: \(error.localizedDescription)")
    }
    
    private func mapToUIModel(_ data: WeatherData) -> WeatherUIModel {
        let temp = "\(Int(data.main.temp))°"
        let max = Int(data.main.tempMax)
        let min = Int(data.main.tempMin)
        
        return WeatherUIModel(
            cityName: data.name,
            temperature: temp,
            description: data.weather.first?.description ?? "Нет данных",
            minMax: "Макс:\(max)°  Мин:\(min)°"
        )
    }
    
}
