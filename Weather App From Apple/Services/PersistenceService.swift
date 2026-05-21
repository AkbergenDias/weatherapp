//
//  PersistenceService.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 10.05.2026.
//
import Foundation

final class PersistenceService: PersistenceServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let citiesKey = "saved_cities_key"
    private let maxLimit = 3
    
    func getSavedCities() -> [String] {
        return userDefaults.stringArray(forKey: citiesKey) ?? []
    }
    
    func saveCity(_ name: String) -> Bool {
        var currentCities = getSavedCities()
        
        if currentCities.contains(name) { return true }
        
        guard currentCities.count < maxLimit else { return false }
        
        currentCities.append(name)
        userDefaults.set(currentCities, forKey: citiesKey)
        return true
    }
}
