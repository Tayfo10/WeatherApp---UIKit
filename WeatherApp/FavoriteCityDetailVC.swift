//
//  FavoriteCityDetailVC.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 23.07.2024.
//

import UIKit

class FavoriteCityDetailVC: UIViewController {
    
    var favoriteCity: FavoriteCity?
    private let gradientLayer = CAGradientLayer()
    let customTransitionDelegate = CustomTransitionDelegate()

    private let weatherImageView = UIImageView()
    private let cityNameLabel = WALabel(text: "", fontSize: 24, textAlignment: .center)
    private let temperatureLabel = WALabel(text: "", fontSize: 20, textAlignment: .center)
    private let weatherDescriptionLabel = WALabel(text: "", fontSize: 18, textAlignment: .center)
    private let timestampLabel = WALabel(text: "", fontSize: 16, textAlignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if let favoriteCity = favoriteCity {
            updateUI(with: favoriteCity)
            animateBackground(for: favoriteCity.weatherDescription)
        }
    }
    
    private func configureUI() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let stackView = UIStackView(arrangedSubviews: [cityNameLabel, temperatureLabel, weatherImageView, weatherDescriptionLabel, timestampLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func updateUI(with favoriteCity: FavoriteCity) {
        cityNameLabel.text = favoriteCity.cityName
        temperatureLabel.text = favoriteCity.temperature
        weatherDescriptionLabel.text = favoriteCity.weatherDescription
        timestampLabel.text = favoriteCity.timestamp
        
        let iconName = WeatherUtils.getWeatherIconName(for: favoriteCity.weatherDescription)
        weatherImageView.image = UIImage(named: iconName)
        weatherImageView.contentMode = .scaleAspectFit
    }

    private func animateBackground(for weatherDescription: String) {
        let colors = GradientHelper.getWeatherGradient(for: weatherDescription)
        gradientLayer.colors = colors.startColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        
        GradientHelper.animateGradient(view: view, from: colors.startColors, to: colors.endColors)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}
