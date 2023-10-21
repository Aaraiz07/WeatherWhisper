//
//  WeatherManager.swift
//  WeatherWhisper
//
//  Created by Aaraiz Wasim on 18/10/2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=c5bba05cb5d3659796080dbed5c60791"
    
    func fetchWeather(for city: String) {
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(urlString)
    }
    
    func fetchWeather(for longitude: CLLocationDegrees, _ latitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lon=\(longitude)&lat=\(latitude)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            print(error)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
