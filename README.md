
# WeatherApp iOS - UIKit

![WeatherApplogo](https://github.com/user-attachments/assets/2f1946bb-3f76-4970-8afb-bc9d46d50589)

Welcome to the Weather App project! This app provides real-time weather updates, forecasts, and the ability to save favorite locations. Below are some screenshots and a list of key features.


## Screenshots

### MainVC
![simulator_screenshot_BFA898C1-C9D5-4097-B35D-3B80B1D06B95](https://github.com/user-attachments/assets/d9717410-e0a0-411b-9ab9-1e02c9ddb6c7)
### FavoritesVC
![simulator_screenshot_B06CCD8D-F977-491D-B05B-BAE92CE36E54](https://github.com/user-attachments/assets/d1b7263f-9be7-47b0-ba53-4c475ada8e0a)
### SearchVC
![simulator_screenshot_562B4725-FA58-442F-B0DC-BF6D476CFEBF](https://github.com/user-attachments/assets/8e5bdc1b-4520-440d-9fd3-6c0862cd8ac3)




## Features

- **Current Location Weather:** Get weather updates for your current location using GPS.
- **Search Weather:** Search weather information for any city by typing in the city name.
- **Weather Forecasts:** View detailed 5-day forecasts with 3-hour intervals for both current and searched locations.
- **Favorites:** Save your favorite locations for quick access and easily view their weather information.
- **Interactive UI:** Smooth transitions and animations, including a custom expand animation similar to the Apple Weather app.

## Technical Features

### Networking

- The app uses the OpenWeatherMap API to fetch current weather data and forecasts.
- Networking is handled using URLSession with support for async/await for modern and efficient asynchronous code.
- Error handling is robust, ensuring that the user is informed of any network issues or data retrieval problems.

### Data Management

- Data models are defined to match the structure of the JSON responses from the OpenWeatherMap API.
- All data models are separated into their own files for better organization and maintainability.
- The app uses Codable protocol for easy and efficient parsing of JSON data.

### Architecture

- The app follows the MVVM (Model-View-ViewModel) architecture pattern, promoting separation of concerns and making the codebase more modular and testable.
- ViewControllers handle user interactions and UI updates.
- ViewModels handle business logic and data manipulation.
- Models represent the data structures.
