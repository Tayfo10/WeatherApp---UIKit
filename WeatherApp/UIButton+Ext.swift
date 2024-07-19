//
//  UIButton+Ext.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 19.07.2024.
//

import UIKit

extension UIButton {
    func applyGlassEffect() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
    }
}
