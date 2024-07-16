//
//  SearchVC.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 12.07.2024.
//

import UIKit
import CoreLocation

class SearchVC: UIViewController {
    
    var weatherData: WeatherResponse?
    var placemark: CLPlacemark?
    var cityName: String?
    
    let cityLabel = WALabel(text: "", fontSize: 40, textAlignment: .center)
    
    let dateLabel = WALabel(text: "", fontSize: 24, textAlignment: .center)
    
    let dayLabel = WALabel(text: "", fontSize: 24, textAlignment: .center)
    
    var temperatureLabel = WALabel(text: "", fontSize: 62, textAlignment: .center)
    
    var humidityLabel = WALabel(text: "", fontSize: 28, textAlignment: .center)
    
    let weatherDescription = WALabel(text: "", fontSize: 20, textAlignment: .center)
    
    let windLabel = WALabel(text: "", fontSize: 20, textAlignment: .center)
    
    let weatherImage = WAImageView(imageName: "weatherlogo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        
        if let weather = weatherData, let placemark = placemark {
            updateUI(with: weather, placemark: placemark)
        }
        
    }
    
    func configureUI() {
        
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(cityLabel)
        view.addSubview(dateLabel)
        view.addSubview(weatherImage)
        view.addSubview(temperatureLabel)
        view.addSubview(humidityLabel)
        view.addSubview(weatherDescription)
        view.addSubview(windLabel)
        view.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            dayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50),
            weatherImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherImage.heightAnchor.constraint(equalToConstant: 120),
            weatherImage.widthAnchor.constraint(equalToConstant: 120),
            
            temperatureLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 40),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            humidityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            humidityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherDescription.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor),
            weatherDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            windLabel.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor),
            windLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    func updateUI(with weather: WeatherResponse, placemark: CLPlacemark) {
        DispatchQueue.main.async {
            self.cityLabel.text = self.cityName
            self.dateLabel.text = WeatherUtils.getCurrentDate()
            self.dayLabel.text = WeatherUtils.getCurrentDay()
            self.temperatureLabel.text = WeatherUtils.celciusToUI(celcius: weather.main.temp)
            self.humidityLabel.text = "Humidity:\(weather.main.humidity)%"
            self.weatherDescription.text =  weather.weather.first?.description.capitalized
            self.windLabel.text = "\(weather.wind.speed) m/s"
            
            if let weatherDescription = weather.weather.first?.description {
                let iconName = WeatherUtils.getWeatherIconName(for: weatherDescription)
                self.weatherImage.image = UIImage(named: iconName)
                
                if weatherDescription.contains("clear") || weatherDescription.contains("sun") {
                    GradientHelper.animateGradient(view: self.view, from: [UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor],
                                         to: [UIColor.systemOrange.cgColor, UIColor.systemYellow.cgColor])
                } else if weatherDescription.contains("cloud") {
                    GradientHelper.animateGradient(view: self.view, from: [UIColor.darkGray.cgColor, UIColor.gray.cgColor],
                                         to: [UIColor.gray.cgColor, UIColor.darkGray.cgColor])
                } else if weatherDescription.contains("rain") || weatherDescription.contains("storm") {
                    GradientHelper.animateGradient(view: self.view, from: [UIColor.systemBlue.cgColor, UIColor.darkGray.cgColor],
                                         to: [UIColor.darkGray.cgColor, UIColor.systemBlue.cgColor])
                } else {
                    GradientHelper.animateGradient(view: self.view, from: [UIColor.systemTeal.cgColor, UIColor.systemBlue.cgColor],
                                         to: [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor])
                }
            }
        }
    }
}
