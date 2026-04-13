//
//  ViewController.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 12.04.2026.
//

import UIKit
import SnapKit

class WeatherViewController: UIViewController {
    
    private let viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("WeatherViewController загружен")
    }
}
