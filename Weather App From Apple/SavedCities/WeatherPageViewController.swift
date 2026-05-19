//
//  WeatherPageViewController.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 18.05.2026.
//

import UIKit
import SnapKit

enum PageDirection {
    case next
    case previous
}

class WeatherPageViewController: UIPageViewController {
    
    private let viewModel = WeatherViewModel(
        networkService: DIContainer.shared.networkService,
        locationManager: DIContainer.shared.locationManager,
        persistenceService: DIContainer.shared.persistenceService
    )
    
    private var pages: [UIViewController] = []
    
    private var savedCitiesVC: SavedCitiesViewController?
    private var tabBarView: WeatherTabBarView?
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColorManager.mainBackground
        dataSource = self
        delegate = self
        setupBindings()
        viewModel.start()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onCitiesListRefreshed = { [weak self] in
            DispatchQueue.main.async { self?.rebuildPages() }
        }
        viewModel.onActiveIndexChanged = { [weak self] newIndex in
            DispatchQueue.main.async {
                self?.switchToPage(at: newIndex)
                self?.tabBarView?.updatePageIndicator(for: newIndex)}
        }
    }

    
    private func rebuildPages() {
        pages = viewModel.savedCities.enumerated().map { index, _ in
            WeatherViewController(cityIndex: index, viewModel: viewModel)
        }

        let targetIndex = min(viewModel.currentCityIndex, max(0, pages.count - 1))
        if let firstPage = pages.safeObject(at: targetIndex) {
            setViewControllers([firstPage], direction: .forward, animated: false)
        }

    }
    
    private func switchToPage(at index: Int) {
        guard let targetVC = pages.safeObject(at: index) else { return }

        let direction: UIPageViewController.NavigationDirection =
            index >= viewModel.currentCityIndex ? .forward : .reverse
        viewModel.currentCityIndex = index

        setViewControllers([targetVC], direction: direction, animated: true)
    }
    
    func movePage(direction: PageDirection) {
        let targetIndex = direction == .next
        ? viewModel.currentCityIndex + 1
        : viewModel.currentCityIndex - 1
        
        guard targetIndex >= 0 && targetIndex < pages.count else { return }
        switchToPage(at: targetIndex)
    }
    
    func openSavedCitiesList() {
        guard let window = view.window else { return }
        let vc = SavedCitiesViewController()
        vc.delegate = self
        vc.weatherStateProvider = { [weak self] index in
            self?.viewModel.getState(for: index)
        }
        savedCitiesVC = vc

        addChild(vc)
        vc.view.frame = window.bounds
        vc.view.transform = CGAffineTransform(translationX: 0, y: window.bounds.height)
        window.addSubview(vc.view)
        vc.didMove(toParent: self)

        UIView.animate(withDuration: 0.45,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut) {
            self.viewControllers?.first?.view.transform =
                CGAffineTransform(scaleX: 0.92, y: 0.92)
            vc.view.transform = .identity
        }
    }
    
private func closeSavedCitiesList() {
        guard let vc = savedCitiesVC else { return }

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn) {
            self.viewControllers?.first?.view.transform = .identity
            vc.view.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        } completion: { _ in
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            self.savedCitiesVC = nil
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension WeatherPageViewController: UIPageViewControllerDataSource {
    
    // Left
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        return pages.safeObject(at: currentIndex - 1)
    }
    
    // Right
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        return pages.safeObject(at: currentIndex + 1)
    }
}

// MARK: - UIPageViewControllerDelegate
extension WeatherPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first,
           let newIndex = pages.firstIndex(of: currentVC) {
            viewModel.currentCityIndex = newIndex
            tabBarView?.updatePageIndicator(for: newIndex)
        }
    }
}

// MARK: - SavedCitiesViewControllerDelegate
extension WeatherPageViewController: SavedCitiesViewControllerDelegate {
    func didSelectCity(at index: Int) {
        closeSavedCitiesList()
        switchToPage(at: index)
    }
    
    func didAddNewCity(_ cityName: String) {
        closeSavedCitiesList()
        
        viewModel.reloadCities()
        rebuildPages()
        
        let targetIndex = 1
        viewModel.currentCityIndex = targetIndex
        guard let targetVC = pages.safeObject(at: targetIndex) else { return }
        setViewControllers([targetVC], direction: .forward, animated: false, completion: nil)
    }

    func didUpdateCitiesList() {
        closeSavedCitiesList()
        // If the current city was deleted, clamp to a valid neighbour
        let safeIndex = min(viewModel.currentCityIndex, max(0, viewModel.savedCities.count - 1))
        viewModel.currentCityIndex = safeIndex
        viewModel.reloadCities()
    }

    func didRequestClose() {
        closeSavedCitiesList()
    }
}

extension Array {
    func safeObject(at index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}
