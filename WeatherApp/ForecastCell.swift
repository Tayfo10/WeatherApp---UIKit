//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 18.07.2024.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    private let blurEffectView: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
            return blurEffectView
        }()
    
    private let dayLabel = WALabel(text: "", fontSize: 24, textAlignment: .left)
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let maxTempLabel = WALabel(text: "", fontSize: 24, textAlignment: .right)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCellAppearance()
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellAppearance() {
            contentView.backgroundColor = .clear
            
            contentView.layer.cornerRadius = 12
            contentView.layer.masksToBounds = true
        }

    private func setupViews() {
        
        contentView.addSubview(blurEffectView)
               contentView.sendSubviewToBack(blurEffectView)
               
               NSLayoutConstraint.activate([
                   blurEffectView.topAnchor.constraint(equalTo: contentView.topAnchor),
                   blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                   blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                   blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
               ])
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(maxTempLabel)
        
        NSLayoutConstraint.activate([
            
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            weatherImageView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 15),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 60),
            weatherImageView.heightAnchor.constraint(equalToConstant: 60),
            
            maxTempLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 8),
            maxTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            maxTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    func configure(day: String, minTemp: Double, maxTemp: Double, weatherDescription: String) {
        dayLabel.text = day
        maxTempLabel.text = "\(Int(maxTemp))°C"
        let iconName = WeatherUtils.getWeatherIconName(for: weatherDescription)
        weatherImageView.image = UIImage(named: iconName)
    }
}
