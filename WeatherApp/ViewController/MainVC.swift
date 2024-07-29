//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 11.07.2024.
//

import UIKit
import CoreLocation

class MainVC: UIViewController{
    
    var weatherForecastData: WeatherForecastResponse?
    var searchWeatherData: WeatherResponse?
    var weatherData: WeatherResponse?
    var placemark: CLPlacemark?
    var cityName: String?
    var citySearchName: String?
    
    private let showForecastButton = WAButton()
    
    let weatherService      = WeatherService(apiKey: "899331ae7b7d2cbd88b2096d962b91e7")
    let cityLabel           = WALabel(text: "", fontSize: 40, textAlignment: .center)
    let dateLabel           = WALabel(text: "", fontSize: 24, textAlignment: .center)
    let dayLabel            = WALabel(text: "", fontSize: 24, textAlignment: .center)
    var temperatureLabel    = WALabel(text: "", fontSize: 62, textAlignment: .center)
    var humidityLabel       = WALabel(text: "", fontSize: 28, textAlignment: .center)
    let weatherDescription  = WALabel(text: "", fontSize: 20, textAlignment: .center)
    let windLabel           = WALabel(text: "", fontSize: 20, textAlignment: .center)
    let weatherImage        = WAImageView(imageName: "weatherlogo")
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let weather = weatherData, let placemark = placemark {
            updateUI(with: weather, placemark: placemark)
        }
        configureUI()
        configureSearchBar()
        configureForecastButton()
        tapGestureAdd()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        searchBar.layer.removeAllAnimations()
        view.endEditing(true)
        resetSearchData()
    }
    
    private func resetSearchData() {
        citySearchName = nil
        searchWeatherData = nil
    }
    
    @objc private func showForecastButtonTapped() {
        let forecastVC = ForecastVC()
        forecastVC.cityName = self.cityName!
        forecastVC.weatherForecastData = self.weatherForecastData
        forecastVC.fromMainVC = true
        navigationController?.pushViewController(forecastVC, animated: true)
    }
    
    private func setupNavigationBar() {
        WeatherApp.setupNavigationBar(for: self, addToFavoritesSelector: #selector(addToFavorites), showFavoritesSelector: #selector(showFavorites))
        }
    
    @objc private func showFavorites() {
        let favoritesVC = FavoritesVC()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    @objc private func addToFavorites() {
        guard let cityName = self.cityName,
              let weatherDescription = weatherDescription.text,
              let temperature = temperatureLabel.text else { return }
        
        let timestamp = WeatherUtils.getCurrentDateTime()
        let favoriteCity = FavoriteCity(cityName: cityName, temperature: temperature, weatherDescription: weatherDescription, timestamp: timestamp)
        
        if FavoriteCitiesManager.shared.getFavoriteCities().contains(where: { $0.cityName == cityName }) {
            showAlert(title: "Already in Favorites", message: "\(cityName) is already in your favorites.")
        } else {
            FavoriteCitiesManager.shared.addFavorite(city: favoriteCity)
            showAlert(title: "Added to Favorites", message: "\(cityName) has been added to your favorites.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureForecastButton () {
        showForecastButton.configuration = .filled()
        showForecastButton.addTarget(self, action: #selector(showForecastButtonTapped), for: .touchUpInside)
    }
    
    func configureSearchBar (){
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Enter city name"
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.textColor = .gray
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
        }
    }
    
    func tapGestureAdd() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func configureUI() {
        
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(showForecastButton)
        view.addSubview(cityLabel)
        view.addSubview(dateLabel)
        view.addSubview(weatherImage)
        view.addSubview(temperatureLabel)
        view.addSubview(humidityLabel)
        view.addSubview(weatherDescription)
        view.addSubview(windLabel)
        view.addSubview(dayLabel)
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            
            cityLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            dayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50),
            weatherImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherImage.heightAnchor.constraint(equalToConstant: 120),
            weatherImage.widthAnchor.constraint(equalToConstant: 120),
            
            showForecastButton.topAnchor.constraint(equalTo: weatherImage.bottomAnchor),
            showForecastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: showForecastButton.bottomAnchor, constant: 40),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            humidityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            humidityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherDescription.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor),
            weatherDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            windLabel.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor),
            windLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    
    func updateUI(with weather: WeatherResponse, placemark: CLPlacemark) {
        DispatchQueue.main.async {
            self.cityLabel.text = self.cityName
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
            
            if let weatherDescription = weather.weather.first?.description{
                
                if weatherDescription.contains("clear") || weatherDescription.contains("sun") {
                    GradientHelper.animateGradient(view: self.view, from: GradientHelper.yellowOrange,
                                                   to: GradientHelper.whiteYellow)
                } else if weatherDescription.contains("cloud") {
                    GradientHelper.animateGradient(view: self.view, from: GradientHelper.blueDarkGray,
                                                   to: GradientHelper.whiteGray)
                } else if weatherDescription.contains("rain") || weatherDescription.contains("storm") {
                    GradientHelper.animateGradient(view: self.view, from: GradientHelper.blueDarkGray,
                                                   to: GradientHelper.darkGrayBlue)
                } else {
                    GradientHelper.animateGradient(view: self.view, from: GradientHelper.blueTeal,
                                                   to: GradientHelper.tealBlue)
                }
            }
        }
    }
    
    func navigateToSearchVC(with weatherResponse: WeatherResponse){
        let searchVC = SearchVC()
        searchVC.citySearchName = self.citySearchName
        searchVC.cityName = self.cityName
        searchVC.weatherData = self.searchWeatherData
        searchVC.placemark = self.placemark
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func performAPICall(for cityName: String) {
        Task {
            do {
                self.searchWeatherData = try await weatherService.fetchWeatherCity(city: cityName)
                navigateToSearchVC(with: searchWeatherData!)
            } catch {
                print("Failed to fetch weather data: \(error)")
            }
        }
    }
}

extension MainVC:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let cityName = searchBar.text, !cityName.isEmpty else { return }
        self.cityName = cityName
        performAPICall(for: cityName)
        self.citySearchName = cityName
    }
}
