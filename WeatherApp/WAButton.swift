//
//  WAButton.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 18.07.2024.
//

import UIKit

class WAButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        setTitle("Show Forecast", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
