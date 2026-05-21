//
//  PesistanceServiceProtocol.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 10.05.2026.
//

import Foundation

protocol PersistenceServiceProtocol {
    func getSavedCities() -> [String]
    func saveCity(_ name: String) -> Bool
}
