//
//  FavoriteCitiesManager.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 20.07.2024.
//

import Foundation

struct FavoriteCity: Codable {
    let cityName: String
    let temperature: String
    let weatherDescription: String
    let timestamp: String
}


class FavoriteCitiesManager {
    static let shared = FavoriteCitiesManager()
    private let favoritesKey = "favoriteCities"

    func getFavoriteCities() -> [FavoriteCity] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favoriteCities = try? JSONDecoder().decode([FavoriteCity].self, from: data) else {
            return []
        }
        return favoriteCities
    }

    func addFavorite(city: FavoriteCity) {
        var favorites = getFavoriteCities()
        favorites.append(city)
        saveFavoriteCities(favorites)
    }

    func removeFavorite(cityName: String) {
        var favorites = getFavoriteCities()
        favorites.removeAll { $0.cityName == cityName }
        saveFavoriteCities(favorites)
    }

    func clearFavorites() {
        saveFavoriteCities([])
    }

    private func saveFavoriteCities(_ cities: [FavoriteCity]) {
        if let data = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}
