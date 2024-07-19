//
//  ForecastVC.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 17.07.2024.
//

import UIKit

class ForecastVC: UIViewController {
    
    var fromMainVC: Bool = false


    var weatherForecastData: WeatherForecastResponse? {
        didSet {
            filterForecasts()
        }
    }
    
    private var filteredForecasts: [WeatherForecast] = []

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Set the scroll direction to vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: "ForecastCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func updateBackground(for weatherDescription: String) {
            if weatherDescription.contains("clear") || weatherDescription.contains("sun") {
                GradientHelper.animateGradient(view: self.view, from: GradientHelper.yellowOrange, to: GradientHelper.whiteYellow)
            } else if weatherDescription.contains("cloud") {
                GradientHelper.animateGradient(view: self.view, from: GradientHelper.blueDarkGray, to: GradientHelper.whiteGray)
            } else if weatherDescription.contains("rain") || weatherDescription.contains("storm") {
                GradientHelper.animateGradient(view: self.view, from: GradientHelper.blueDarkGray, to: GradientHelper.darkGrayBlue)
            } else {
                GradientHelper.animateGradient(view: self.view, from: GradientHelper.blueTeal, to: GradientHelper.tealBlue)
            }
        }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 480),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5),
            
        ])
    }

    private func filterForecasts() {
        guard let forecasts = weatherForecastData?.list else {
            print("No forecast data available")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let calendar = Calendar.current
        filteredForecasts = forecasts.filter { forecast in
            if let date = dateFormatter.date(from: forecast.dt_txt) {
                let components = calendar.dateComponents([.hour], from: date)
                return components.hour == 12
            }
            return false
        }

        print("Filtered forecasts: \(filteredForecasts.count)")

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ForecastVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredForecasts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
                let forecast = filteredForecasts[indexPath.row]
                var minTemp = forecast.main.temp_min
                var maxTemp = forecast.main.temp_max

                if fromMainVC {
                    minTemp = Double(minTemp - 273)
                    maxTemp = Double(maxTemp - 273)
                }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: forecast.dt_txt) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            let dayName = dayFormatter.string(from: date)
            
            if let weatherDescription = forecast.weather.first?.description {
                cell.configure(day: dayName, minTemp: minTemp, maxTemp: maxTemp, weatherDescription: weatherDescription)
                updateBackground(for: weatherDescription)

            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 75)
    }
}
