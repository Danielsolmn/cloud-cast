//
//  WeatherForecastService.swift
//  CloudCast
//
//  Created by Daniel Woldetsadik on 7/8/25.
//

import Foundation

class WeatherForecastService {
    static func fetchForecast(latitude: Double,
                              longitude: Double,
                              completion: ((CurrentWeatherForecast) -> Void)? = nil) {
        
        // Build the URL with parameters
        let parameters = "latitude=\(latitude)&longitude=\(longitude)&current_weather=true&temperature_unit=fahrenheit&timezone=auto&wind_speed_unit=mph"
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?\(parameters)") else {
            print("Invalid URL")
            return
        }
        
        // Create a network task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Handle error
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }

            // Check valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid HTTP response")
                return
            }

            // Make sure we got data
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Decode JSON using JSONDecoder and your structs
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(WeatherAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion?(decodedResponse.currentWeather)
                }
            } catch {
                print("Decoding failed: \(error.localizedDescription)")
            }
        }
        
        // Start the task
        task.resume()
    }
}
