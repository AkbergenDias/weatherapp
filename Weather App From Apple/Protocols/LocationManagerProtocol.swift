//
//  LocationManagerProtocol.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import Foundation

protocol LocationManagerProtocol {
    var delegate: LocationManagerDelegate? { get set }
    func requestLocation()
}
