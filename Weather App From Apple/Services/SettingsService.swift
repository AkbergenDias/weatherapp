//
//  SettingsService.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 20.05.2026.
//

import Foundation

enum TemperatureUnit: String {
    case celsius, fahrenheit
}

final class SettingsService {
    static let shared = SettingsService()
    private init() {}

    private let unitKey = "temperature_unit"

    var temperatureUnit: TemperatureUnit {
        get {
            let raw = UserDefaults.standard.string(forKey: unitKey) ?? "celsius"
            return TemperatureUnit(rawValue: raw) ?? .celsius
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: unitKey)
            NotificationCenter.default.post(name: .temperatureUnitChanged, object: nil)
        }
    }
}

extension Notification.Name {
    static let temperatureUnitChanged = Notification.Name("temperatureUnitChanged")
}
