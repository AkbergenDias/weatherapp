//
//  AppDelegate.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let container = DIContainer.shared
        
        let viewModel = WeatherViewModel(
            networkService: container.networkService,
            locationManager: container.locationManager
        )
        
        let rootVC = WeatherViewController(viewModel: viewModel)
        self.window?.rootViewController = rootVC
        
        self.window?.makeKeyAndVisible()
        
        return true
    }



}

