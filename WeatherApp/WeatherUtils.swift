//
//  WeatherUtils.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 12.07.2024.
//

import Foundation

struct WeatherUtils {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: Date())
    }
    
    static func getCurrentDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
    }
    
    static func kelvinToCelsius(kelvin: Double) -> String {
        let celsius = kelvin - 273.15
        return String(format: "%.1f°C", celsius)
    }
    
    static func getWeatherIconName(for description: String) -> String {
        switch description.lowercased() {
        case "clear sky":
            return "clear_sky"
        case "few clouds":
            return "few_clouds"
        case "scattered clouds":
            return "scattered_clouds"
        case "broken clouds":
            return "broken_clouds"
        case "shower rain":
            return "shower_rain"
        case "rain":
            return "rain"
        case "moderate rain":
            return "rain"
        case "light rain":
            return "rain"
        case "thunderstorm with light rain":
            return "rain"
        case "thunderstorm":
            return "thunderstorm"
        case "snow":
            return "snow"
        case "mist":
            return "mist"
        default:
            return "default_weather"
        }
    }
}
