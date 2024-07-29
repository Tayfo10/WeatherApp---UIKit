//
//  WAImageView.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 11.07.2024.
//

import UIKit

class WAImageView: UIImageView {
    
    init(imageName: String, contentMode: UIView.ContentMode = .scaleAspectFit) {
        super.init(frame: .zero)
        self.image = UIImage(named: imageName)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.cornerRadius = 200
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.systemBlue.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 4, height: 2)
        self.layer.shadowRadius = 40
        self.layer.masksToBounds = false
        
    }
}
