//
//  AppColorManager.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import Foundation
import UIKit

enum AppTextStyle {
    case header
    case body
    
    var font: UIFont {
        switch self {
        case .header: return .systemFont(ofSize: 32, weight: .bold)
        case .body: return .systemFont(ofSize: 16, weight: .regular)
        }
    }
}

struct AppColorManager {
    static let mainBackground = UIColor(named: "2B4F73")
    static let primaryText = UIColor.white
}
