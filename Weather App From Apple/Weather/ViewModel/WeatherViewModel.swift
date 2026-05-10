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
    private let persistenceService: PersistenceServiceProtocol
    
    private(set) var savedCities: [String] = []
    private var currentCityIndex: Int = 0
    
    init(networkService: NetworkServiceProtocol, locationManager: LocationManagerProtocol, persistenceService: PersistenceServiceProtocol = DIContainer.shared.persistenceService) {
        self.networkService = networkService
        self.locationManager = locationManager
        self.persistenceService = persistenceService
        loadCities()
        locationManager.requestLocation()
        self.locationManager.delegate = self
    }
    
    func loadCities() {
        let saved = persistenceService.getSavedCities()
        
        var list = ["Текущее место"]
        list.append(contentsOf: saved)
        self.savedCities = list
    }
    
    func switchToNextCity() {
        guard !savedCities.isEmpty else { return }
        currentCityIndex = (currentCityIndex + 1) % savedCities.count
        fetchWeatherForActiveIndex()
    }
    
    func switchToPreviousCity() {
        guard !savedCities.isEmpty else { return }
        currentCityIndex = (currentCityIndex - 1 + savedCities.count) % savedCities.count
        fetchWeatherForActiveIndex()
    }
    
    private func fetchWeatherForActiveIndex() {
        if currentCityIndex == 0 {
            print("Запрашиваем погоду по текущей геолокации...")
            locationManager.requestLocation()
        } else {
            let cityName = savedCities[currentCityIndex]
            print("Запрашиваем погоду по названию города: \(cityName)")
        }
    }
    
    func refreshWeather() {
        fetchWeatherForActiveIndex()
    }
    
    func didUpdateLocation(lat: Double, lon: Double) {
        onStateChange?(.loading)
        print("Координаты получены: \(lat), \(lon)")
        
        //API оставил для домашки без git ignore
        let apiKey = "6dc2788ca091c6b2364a1891d83f95f4"
        guard let weatherUrl = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"),
            let forecastUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"),
            let uvUrl = URL(string: "https://api.openweathermap.org/data/2.5/uvi?lat=\(lat)&lon=\(lon)&appid=\(apiKey)")
        else {
            self.onStateChange?(.error("Ошибка формирования URL"))
            return
        }
        
        Task {
            do {
                async let weatherFetch: WeatherData = try await networkService.fetch(url: weatherUrl)
                async let forecastFetch: ForecastResponse = try await networkService.fetch(url: forecastUrl)
                async let uvFetch: UVResponse = try await networkService.fetch(url: uvUrl)
                
                let (weatherData, forecastData, uvData) = try await (weatherFetch, forecastFetch, uvFetch)
                            
                let uiModel = mapToUIModel(weatherData, forecastData: forecastData, uvData: uvData)
                
                await MainActor.run {
                    self.onStateChange?(.success(uiModel))
                }
            } catch {
                print("Full error: \(error)")

                await MainActor.run { self.onStateChange?(.error(error.localizedDescription)) }
            }
        }
    }
        
    private func mapToUIModel(_ weatherData: WeatherData, forecastData: ForecastResponse, uvData: UVResponse) -> WeatherUIModel {
        
        // Hourly and Daily
        let hourlyModels = mapToHourly(forecastData)
        let dailyModels = mapToDaily(forecastData)
        
        // Avarage
        let dailyMaxTemps = forecastData.list.map { $0.main.tempMax }
        let calculatedAverageMax = dailyMaxTemps.reduce(0, +) / Double(dailyMaxTemps.count)
        
        let todayMaxTemp = weatherData.main.tempMax
        
        // Difference
        let difference = Int(todayMaxTemp - calculatedAverageMax)
        let diffString = difference > 0 ? "+\(difference)°" : "\(difference)°"
        let descString = difference >= 0 ? "выше среднего максимума" : "ниже среднего максимума"
        
        // Km/h from m/s
        let speedKmH = Int(weatherData.wind.speed * 3.6)
        let windSpeedStr = "\(speedKmH) км/ч"

        // Gusts
        let gustKmH = weatherData.wind.gust.map { Int($0 * 3.6) }
        let windGustStr = gustKmH != nil ? "\(gustKmH!) км/ч" : "-- км/ч"

        // Wind direction
        let windDirStr = weatherData.wind.deg != nil ? getWindDirection(degrees: weatherData.wind.deg!) : "--"
        
        // UV
        let uvVal = uvData.value
        let uvLevelStr: String
        let uvDescStr: String
        if uvVal <= 2 {
            uvLevelStr = "Низкий"
            uvDescStr = "Останется низким до конца дня."
        } else if uvVal <= 5 {
            uvLevelStr = "Умеренный"
            uvDescStr = "Используйте SPF защиту в середине дня."
        } else if uvVal <= 7 {
            uvLevelStr = "Высокий"
            uvDescStr = "Постарайтесь меньше находиться на солнце."
        } else {
            uvLevelStr = "Очень высокий"
            uvDescStr = "Обязательно используйте SPF защиту."
        }
        let uvProgressVal = CGFloat(uvVal / 11.0)
        
        // Sunset
        var isSunsetMain = true
        var mainSunTimeStr = "-:-"
        var subSunTimeStr = "Восход в -:-"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let sys = weatherData.sys {
            let currentTimestamp = Int(Date().timeIntervalSince1970)
            let sunriseDate = Date(timeIntervalSince1970: TimeInterval(sys.sunrise))
            let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sys.sunset))
            
            let sunriseStr = formatter.string(from: sunriseDate)
            let sunsetStr = formatter.string(from: sunsetDate)
            
            if currentTimestamp < sys.sunset {
                isSunsetMain = true
                mainSunTimeStr = sunsetStr
                subSunTimeStr = "Восход в \(sunriseStr)."
            } else {
                isSunsetMain = false
                mainSunTimeStr = sunriseStr
                subSunTimeStr = "Закат в \(sunsetStr)."
            }
        }
        
        //Humiditty
        let humidityVal = weatherData.main.humidity
        let tempVal = weatherData.main.temp
        let dewPointVal = Int(tempVal - ((100.0 - Double(humidityVal)) / 5.0))
        let dewPointStr = "Точка росы сейчас: \(dewPointVal)°."
        
        let pressureVal = weatherData.main.pressure
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        let formattedPressure = numberFormatter.string(from: NSNumber(value: pressureVal)) ?? "\(pressureVal)"
        
        // Background
        let condition = weatherData.weather.first?.main ?? "Clear"
        let bgImageName = WeatherBackgroundManager.getBackgroundImageName(
            for: Date(),
            conditionCode: condition
        )
        
        // UIModel
        return WeatherUIModel(
            cityName: weatherData.name,
            temperature: "\(Int(weatherData.main.temp))°",
            description: weatherData.weather.first?.description.capitalized ?? "",
            summary: "Ветер: \(Int(weatherData.wind.speed)) км/ч",
            minMax: "Макс: \(Int(weatherData.main.tempMax))°  Мин: \(Int(weatherData.main.tempMin))°",
            hourlyForecast: hourlyModels,
            dailyForecast: dailyModels,
            feelsLike: "\(Int(weatherData.main.feelsLike))°",
            uvIndex: "\(Int(uvData.value))",
            
            averageDiff: diffString,
            averageDesc: descString,
            todayMax: "\(Int(todayMaxTemp))°",
            averageMax: "\(Int(calculatedAverageMax))°",
            
            windSpeed: windSpeedStr,
            windGusts: windGustStr,
            windDirection: windDirStr,
            
            uvValue: "\(Int(uvVal))",
            uvLevel: uvLevelStr,
            uvDesc: uvDescStr,
            uvProgress: uvProgressVal,
            
            isSunsetMain: isSunsetMain,
            mainSunTime: mainSunTimeStr,
            subSunTimeText: subSunTimeStr,
            
            humidityValue: "\(humidityVal) %",
            dewPointText: dewPointStr,
            
            pressureValue: formattedPressure,
            pressureSubText: "↓ гПА",
            
            backgroundImageName: bgImageName
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
        
        let items = dailyItems.prefix(5)
        
        let allMinTemps = items.map { $0.main.tempMin }
        let allMaxTemps = items.map { $0.main.tempMax }
        
        let weekMin = Int(allMinTemps.min() ?? 0)
        let weekMax = Int(allMaxTemps.max() ?? 0)
        
        return items.map { item in
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = Calendar.current.isDateInToday(date) ? "'Сегодня'" : "EEE"
            
            let isToday = Calendar.current.isDateInToday(date)
            let iconCode = item.weather.first?.icon ?? ""
            return DailyWeather(
                day: formatter.string(from: date).capitalized,
                icon: WeatherIconManager.getIcon(for: iconCode) ?? UIImage(),
                minTemp: (Int(item.main.tempMin)),
                maxTemp: (Int(item.main.tempMax)),
                minTempWeek: weekMin,
                maxTempWeek: weekMax,
                currentTemp: isToday ? Int(item.main.temp) : nil
            )
        }
    }
    
    private func getWindDirection(degrees: Int) -> String {
        let directions = ["С", "СВ", "В", "ЮВ", "Ю", "ЮЗ", "З", "СЗ", "С"]
        let index = Int(round(Double(degrees).truncatingRemainder(dividingBy: 360) / 45.0))
        return "\(degrees)° \(directions[index])"
    }
    
    func didFailWithError(error: Error) {
        print("Ошибка геолокации: \(error.localizedDescription)")
    }
}
