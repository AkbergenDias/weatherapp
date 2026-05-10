//
//  WeatherTabBarDelegate.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 10.05.2026.
//

import UIKit

protocol WeatherTabBarDelegate: AnyObject {
    func tabBarDidTapLeft()
    func tabBarDidTapCenter()
    func tabBarDidTapRight()
    func tabBarDidSwipeUp()
    func tabBarDidSwipeLeft() 
    func tabBarDidSwipeRight()
}
