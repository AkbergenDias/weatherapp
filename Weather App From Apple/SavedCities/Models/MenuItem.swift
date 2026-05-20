//
//  MenuItem.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 20.05.2026.
//

import Foundation
 
struct MenuItem {
    let iconName: String
    let title: String
    let isSystemIcon: Bool
    let isEnabled: Bool
    var isSelected: Bool = false
    let action: (() -> Void)?
}
