//
//  NavigationBarSetup.swift
//  WeatherApp
//
//  Created by Tayfun Sener on 29.07.2024.
//

import UIKit

func setupNavigationBar(for viewController: UIViewController, addToFavoritesSelector: Selector, showFavoritesSelector: Selector) {
    let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: viewController, action: addToFavoritesSelector)
    
    let favoritesButton = UIButton(type: .system)
    favoritesButton.setTitle("Favorites", for: .normal)
    favoritesButton.setTitleColor(.white, for: .normal)
    favoritesButton.backgroundColor = UIColor.systemBlue
    favoritesButton.layer.cornerRadius = 10
    favoritesButton.clipsToBounds = true
    favoritesButton.addTarget(viewController, action: showFavoritesSelector, for: .touchUpInside)
    
    let favoritesBarButton = UIBarButtonItem(customView: favoritesButton)
    favoritesButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        favoritesButton.widthAnchor.constraint(equalToConstant: 100),
        favoritesButton.heightAnchor.constraint(equalToConstant: 30)
    ])
    
    viewController.navigationItem.rightBarButtonItems = [addBarButton, favoritesBarButton]
}
