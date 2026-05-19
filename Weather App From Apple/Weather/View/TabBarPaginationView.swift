//
//  TabBarPaginationView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 18.05.2026.
//
import UIKit

final class PageIndicatorView: UIView {
    private var dots: [UIImageView] = []

    func configure(count: Int, activeIndex: Int) {
        subviews.forEach { $0.removeFromSuperview() }
        dots = (0..<count).map { i in
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            // Replace these
            iv.image = UIImage(named: i == 0 ? "dotLocation" : "dotInactive")
            return iv
        }
        let stack = UIStackView(arrangedSubviews: dots)
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
        setActive(index: activeIndex)
    }

    func setActive(index: Int) {
        dots.enumerated().forEach { i, iv in
            let isActive = i == index
            iv.image = UIImage(named: i == 0 ? "dotLocation" : (isActive ? "dotActive" : "dotInactive"))
            UIView.animate(withDuration: 0.2) { iv.alpha = isActive ? 1.0 : 0.5 }
        }
    }
}
