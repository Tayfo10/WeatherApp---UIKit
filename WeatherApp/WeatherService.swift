//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 12.07.2024.
//

import Foundation

struct WeatherService {
    let apiKey: String
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return weatherResponse
    }
}
