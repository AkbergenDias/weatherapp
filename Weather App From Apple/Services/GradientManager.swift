//
//  GradientManager.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 19.04.2026.
//

import UIKit

enum TimeOfDay {
    case morning
    case day
    case evening
    case night
    
    static func current() -> TimeOfDay {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        switch hour {
        case 5...10: return .morning
        case 11...17: return .day
        case 18...22: return .evening
        default: return .night
        }
    }
}

struct GradientManager {
    static func getGradient(for time: TimeOfDay) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        let colors: [CGColor]
        
        switch time {
        case .morning:
            colors = [UIColor.systemYellow.cgColor, UIColor.white.cgColor]
        case .day:
            colors = [UIColor.systemBlue.cgColor, UIColor.white.cgColor]
        case .evening:
            colors = [UIColor.systemOrange.cgColor, UIColor.white.cgColor]
        case .night:
            colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        }
        
        gradient.colors = colors
        
        return gradient
    }
}
