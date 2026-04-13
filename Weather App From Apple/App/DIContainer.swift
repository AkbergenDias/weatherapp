//
//  DIContainer.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import Foundation

final class DIContainer {
    
    static let shared = DIContainer()
    

    private init() {}
    
    private(set) lazy var networkService: NetworkServiceProtocol = NetworkService()
    private(set) lazy var locationManager: LocationManagerProtocol = LocationManager()
}
