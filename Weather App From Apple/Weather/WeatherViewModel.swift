//
//  WeatherViewModel.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//
import Foundation

class WeatherViewModel: LocationManagerDelegate {
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
                
                print("Ответ от сервера")
                print("Город: \(weatherData.name)")
                print("Температура: \(weatherData.main.temp)°C")
                print("Описание: \(weatherData.weather.first?.description ?? "нет данных")")
                
            } catch {
                print("Ошибка загрузки погоды: \(error)")
            }
        }
    }
    func didFailWithError(error: Error) {
            print("Ошибка геолокации: \(error.localizedDescription)")
        }
    
}
