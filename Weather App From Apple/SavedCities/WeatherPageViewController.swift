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
//    private let indicatorView = CityPageIndicatorView()
    
    private var savedCitiesVC: SavedCitiesViewController?
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1, green: 0.18, blue: 0.28, alpha: 1.0)
        dataSource = self
        delegate = self
        setupBindings()
        viewModel.start()
    }
    
    // MARK: - Indicator
//    private func setupIndicator() {
//        view.addSubview(indicatorView)
//        indicatorView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-88)   // above tab bar
//        }
//    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onCitiesListRefreshed = { [weak self] in
            DispatchQueue.main.async { self?.rebuildPages() }
        }
        viewModel.onActiveIndexChanged = { [weak self] newIndex in
            DispatchQueue.main.async { self?.switchToPage(at: newIndex) }
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

//        indicatorView.configure(count: pages.count, activeIndex: targetIndex)
    }
    
    private func switchToPage(at index: Int) {
        guard let targetVC = pages.safeObject(at: index) else { return }

        let direction: UIPageViewController.NavigationDirection =
            index >= viewModel.currentCityIndex ? .forward : .reverse
        viewModel.currentCityIndex = index

        setViewControllers([targetVC], direction: direction, animated: true)
//        indicatorView.setActive(index: index)
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
        savedCitiesVC = vc

        // Add as child so we control the animation fully
        addChild(vc)
        vc.view.frame = window.bounds
        vc.view.transform = CGAffineTransform(translationX: 0, y: window.bounds.height)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)

        UIView.animate(withDuration: 0.45,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut) {
            self.viewControllers?.first?.view.transform =
                CGAffineTransform(scaleX: 0.92, y: 0.92)
//            self.indicatorView.alpha = 0
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
//            self.indicatorView.alpha = 1
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
        }
    }
}

// MARK: - SavedCitiesViewControllerDelegate
extension WeatherPageViewController: SavedCitiesViewControllerDelegate {
    func didSelectCity(at index: Int) {
        closeSavedCitiesList()
        switchToPage(at: index)
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
