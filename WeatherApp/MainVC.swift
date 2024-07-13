//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 11.07.2024.
//

import UIKit
import CoreLocation

class MainVC: UIViewController {
    
    let locationManager = CLLocationManager()
    
    let weatherService = WeatherService(apiKey: "899331ae7b7d2cbd88b2096d962b91e7")
    
    let cityLabel = WALabel(text: "", fontSize: 40, textAlignment: .center)
    
    let dateLabel = WALabel(text: "", fontSize: 24, textAlignment: .center)
    
    let dayLabel = WALabel(text: "", fontSize: 24, textAlignment: .center)
    
    var temperatureLabel = WALabel(text: "", fontSize: 32, textAlignment: .center)
    
    var humidityLabel = WALabel(text: "", fontSize: 28, textAlignment: .center)
    
    let weatherDescription = WALabel(text: "", fontSize: 20, textAlignment: .center)
    
    let windLabel = WALabel(text: "", fontSize: 20, textAlignment: .center)
    
    let weatherImage = WAImageView(imageName: "weatherlogo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureCreate()
        setupLocationManager()
        configureGradient()
        configureUI()
    }
    
    func tapGestureCreate() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cityLabelTapped))
        cityLabel.isUserInteractionEnabled = true
        cityLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func cityLabelTapped() {
            let newViewController = SearchVC() // Replace with your new view controller class
            navigationController?.pushViewController(newViewController, animated: true)
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
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func updateUI(with weather: WeatherResponse) {
        DispatchQueue.main.async {
            self.dateLabel.text = WeatherUtils.getCurrentDate()
            self.dayLabel.text = WeatherUtils.getCurrentDay()
            self.temperatureLabel.text = WeatherUtils.kelvinToCelsius(kelvin: weather.main.temp)
            self.humidityLabel.text = "Humidity:\(weather.main.humidity)%"
            self.weatherDescription.text =  weather.weather.first?.description.capitalized
            self.windLabel.text = "\(weather.wind.speed) m/s"
            
            if let weatherDescription = weather.weather.first?.description {
                let iconName = WeatherUtils.getWeatherIconName(for: weatherDescription)
                self.weatherImage.image = UIImage(named: iconName)
            }
        }
    }
    
    func configureGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension MainVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            CLGeocoder().reverseGeocodeLocation(location) {placemarks, error in
                if error != nil {
                    print("Reverse geocode has failed!")
                    return
                }
                if let placemark = placemarks?.first{
                    let city = placemark.administrativeArea ?? "Unknown City"
                    let street = placemark.locality ?? "Unknown Locality"
                    let cityLabelText = "\(city), \(street)"
                    DispatchQueue.main.async {
                        self.cityLabel.text = cityLabelText
                    }
                }
            }
            
            Task {
                do {
                    let weather = try await weatherService.fetchWeather(latitude: latitude, longitude: longitude)
                    updateUI(with: weather)
                } catch {
                    print("Failed to fetch weather data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
    
}

