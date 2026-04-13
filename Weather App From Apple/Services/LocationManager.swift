//
//  LocationManager.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import CoreLocation

class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    var onLocationUpdate: ((CLLocation) -> Void)?
    

    
    override init() {
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        }
        
    func locationManager(_ locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            onLocationUpdate?(location)
            
            delegate?.didUpdateLocation(
                            lat: location.coordinate.latitude,
                            lon: location.coordinate.longitude
                        )
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            delegate?.didFailWithError(error: error)
        }
    
}

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(lat: Double, lon: Double)
    func didFailWithError(error: Error)
}
