//
//  SavedCitiesViewModel.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 13.05.2026.
//

import Foundation
import MapKit

enum SearchState {
    case empty
    case searching
    case results([MKLocalSearchCompletion])
    case noResults
    case error(String)
}

class SavedCitiesViewModel: NSObject {
    private let persistenceService: PersistenceServiceProtocol
    private let completer = MKLocalSearchCompleter()
    
    private var debounceTimer: Timer?
        
    private(set) var displayCities: [String] = []
    
    var onSearchStateChange: ((SearchState) -> Void)?
    var onSavedCitiesUpdate: (() -> Void)?
    
    init(persistenceService: PersistenceServiceProtocol = DIContainer.shared.persistenceService) {
        self.persistenceService = persistenceService
        super.init()
        
        completer.delegate = self
        completer.resultTypes = .address
        
        loadSavedCities()
    }
    
    // MARK: - Логика списка городов
    func loadSavedCities() {
        let saved = persistenceService.getSavedCities()
        var list = ["Моя локация"]
        list.append(contentsOf: saved)
        self.displayCities = list
        onSavedCitiesUpdate?()
    }
    
    func deleteCity(at index: Int) {
        guard index != 0 else { return }
        
        let savedCityIndex = index - 1
        var saved = persistenceService.getSavedCities()
        
        guard savedCityIndex < saved.count else { return }
        saved.remove(at: savedCityIndex)
        
        UserDefaults.standard.set(saved, forKey: "saved_cities_key")
        loadSavedCities()
    }
    
    // MARK: - Логика поиска (Debounce 0.35 сек)
    func processSearchInput(_ text: String) {
        debounceTimer?.invalidate()
        
        guard !text.isEmpty else {
            onSearchStateChange?(.empty)
            return
        }
        
        onSearchStateChange?(.searching)
        
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { [weak self] _ in
            self?.completer.queryFragment = text
        }
    }
    
    func selectCompletion(_ completion: MKLocalSearchCompletion, completionHandler: @escaping (CLLocationCoordinate2D?, String?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                completionHandler(nil, nil)
                return
            }
            let cityName = response?.mapItems.first?.name
            completionHandler(coordinate, cityName)
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension SavedCitiesViewModel: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        if completer.results.isEmpty {
            onSearchStateChange?(.noResults)
        } else {
            onSearchStateChange?(.results(completer.results))
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        onSearchStateChange?(.error(error.localizedDescription))
    }
}
