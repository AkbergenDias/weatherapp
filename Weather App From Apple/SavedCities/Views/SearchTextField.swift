//
//  SearchTextField.swift
//  Weather App From Apple
//
//  Created by Диас Акберген on 13.05.2026.
//

import UIKit
import SnapKit

class SearchTextField: UITextField {
    
    var onClearTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupField()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupField() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        self.layer.cornerRadius = 12
        self.textColor = .white
        self.attributedPlaceholder = NSAttributedString(
            string: "Поиск города",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)]
        )
        
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .white.withAlphaComponent(0.4)
        searchIcon.contentMode = .scaleAspectFit
        
        let leftPaddingView = UIView()
        leftPaddingView.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .white.withAlphaComponent(0.4)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        let rightPaddingView = UIView()
        rightPaddingView.addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
        self.rightView = rightPaddingView
        self.rightViewMode = .whileEditing
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 36, height: bounds.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 36, y: 0, width: 36, height: bounds.height)
    }
    
    @objc private func clearTapped() {
        self.text = ""
        onClearTapped?()
    }
}
