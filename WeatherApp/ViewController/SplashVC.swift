//
//  SplashVC.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 13.07.2024.
//

import UIKit
import CoreLocation

class SplashVC: UIViewController {
    
    let weatherService = WeatherService(apiKey: "899331ae7b7d2cbd88b2096d962b91e7")
    let locationManager = CLLocationManager()
    
    var weatherData: WeatherResponse?
    var weatherForecastData: WeatherForecastResponse?
    
    var placemark: CLPlacemark?
    var cityName: String?
    
    let appLabel = WALabel(text: "WeatherApp", fontSize: 32, textAlignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        configureAppLabel()
        fetchData()
    }
    
    private func fetchData() {
        
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            } else { transitionToMainVC() }
        }
    
    private func transitionToMainVC() {
            DispatchQueue.main.async {
                guard let weatherData = self.weatherData, let placemark = self.placemark else { return }
                
                guard let weatherForecastData = self.weatherForecastData else { return }
                
                let mainVC = MainVC()
                mainVC.weatherForecastData = weatherForecastData
                mainVC.weatherData = weatherData
                mainVC.placemark = placemark
                mainVC.cityName = self.cityName
                
                let navigationController = UINavigationController(rootViewController: mainVC)
                navigationController.modalTransitionStyle = .crossDissolve
                navigationController.modalPresentationStyle = .fullScreen
                
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    
    private func transitionToForecastData () {
        DispatchQueue.main.async {
            
            let forecastVC = ForecastVC()
            forecastVC.weatherForecastData = self.weatherForecastData
        }
    }
    
    func configureAppLabel() {
        view.addSubview(appLabel)
        
        NSLayoutConstraint.activate([
            appLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
        ])
    }
}

extension SplashVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Reverse geocode failed with error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    self.placemark = placemark
                    
                    let country = placemark.administrativeArea ?? "Unknown Country"
                    self.cityName = "\(country)"
                    
                    Task {
                        do {
                            
                            self.weatherData = try await self.weatherService.fetchWeather(latitude: latitude, longitude: longitude)
                            
                            self.weatherForecastData = try await self.weatherService.fetchWeatherForecast(latitude: latitude, longitude: longitude)
                            
                            
                            
                            
                            
                            self.transitionToMainVC()
                            
                            
                        } catch {
                            print("Failed to fetch weather data: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
}

