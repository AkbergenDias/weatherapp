//
//  BottomSheetView.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 20.05.2026.
//

import UIKit
import SnapKit

class WeatherOptionsBottomSheetVC: UIViewController {
    
    private lazy var items: [MenuItem] = [
        MenuItem(iconName: "pencil", title: "Изменить список",
                 isSystemIcon: true, isEnabled: false, action: nil),
        MenuItem(iconName: "bell", title: "Уведомления",
                 isSystemIcon: true, isEnabled: false, action: nil),
        MenuItem(iconName: "thermometer", title: "Градусы Цельсия",
                 isSystemIcon: true, isEnabled: true,
                 isSelected: SettingsService.shared.temperatureUnit == .celsius,
                 action: { [weak self] in self?.selectUnit(.celsius) }),
        MenuItem(iconName: "thermometer.low", title: "Градусы Фаренгейта",
                 isSystemIcon: true, isEnabled: true,
                 isSelected: SettingsService.shared.temperatureUnit == .fahrenheit,
                 action: { [weak self] in self?.selectUnit(.fahrenheit) }),
        MenuItem(iconName: "chart.bar", title: "Единицы",
                 isSystemIcon: true, isEnabled: false, action: nil),
        MenuItem(iconName: "exclamationmark.bubble", title: "Сообщить о проблеме",
                 isSystemIcon: true, isEnabled: false, action: nil),
    ]

    // MARK: - UI
    private let handleView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        v.layer.cornerRadius = 2.5
        return v
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorColor = UIColor.white.withAlphaComponent(0.12)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        tv.isScrollEnabled = false
        tv.register(OptionsCell.self, forCellReuseIdentifier: OptionsCell.reuseID)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.11, green: 0.13, blue: 0.18, alpha: 1)
        setupUI()
    }

    private func setupUI() {
        view.addSubview(handleView)
        view.addSubview(tableView)

        handleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(36)
            make.height.equalTo(5)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(handleView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    // MARK: - Actions
    private func selectUnit(_ unit: TemperatureUnit) {
        SettingsService.shared.temperatureUnit = unit
        items[2].isSelected = (unit == .celsius)
        items[3].isSelected = (unit == .fahrenheit)
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0),
                                   IndexPath(row: 3, section: 0)], with: .fade)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

// MARK: - UITableView
extension WeatherOptionsBottomSheetVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionsCell.reuseID,
                                                  for: indexPath) as! OptionsCell
        cell.configure(with: items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 52 }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard items[indexPath.row].isEnabled else { return }
        HapticManager.selectionImpact()
        items[indexPath.row].action?()
    }
}

// MARK: - OptionsCell
private final class OptionsCell: UITableViewCell {
    static let reuseID = "OptionsCell"

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        checkmark.tintColor = .white
        checkmark.contentMode = .scaleAspectFit

        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 17)

        [iconView, titleLabel, checkmark].forEach { contentView.addSubview($0) }

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(22)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        checkmark.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with item: MenuItem) {
        iconView.image = UIImage(systemName: item.iconName)
        titleLabel.text = item.title

        let alpha: CGFloat = item.isEnabled ? 1.0 : 0.4
        iconView.alpha = alpha
        titleLabel.alpha = alpha

        checkmark.isHidden = !item.isSelected
    }
}

