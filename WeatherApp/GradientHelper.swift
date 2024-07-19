//
//  GradientHelper.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 16.07.2024.
//

import UIKit

class GradientHelper {
    
    static let yellowOrange = [UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor]
    
    static let whiteYellow = [UIColor.red.cgColor, UIColor.systemYellow.cgColor]
    
    static let darkgrayGray = [UIColor.darkGray.cgColor, UIColor.gray.cgColor]
    
    static let whiteGray = [UIColor.white.cgColor, UIColor.darkGray.cgColor]
    
    static let blueDarkGray = [UIColor.systemBlue.cgColor, UIColor.darkGray.cgColor]
    
    static let darkGrayBlue = [UIColor.darkGray.cgColor, UIColor.systemBlue.cgColor]
    
    static let blueTeal = [UIColor.systemTeal.cgColor, UIColor.systemBlue.cgColor]
    
    static let tealBlue = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
    
    let yellow = UIColor.systemYellow.cgColor
    let orange = UIColor.systemOrange.cgColor
    
    static func animateGradient(view: UIView, from startColors: [CGColor], to endColors: [CGColor]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = startColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = startColors
        animation.toValue = endColors
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.duration = 12
        
        gradientLayer.add(animation, forKey: "colorChange")
    }
}

